movingAverage <- function(v){
    n <- 51
    N <- nrow(v)
    f <- rep(1 / n, n)
    v[, 2] <- filter(v[, 2], f, side = 2)
    v[, 3] <- filter(v[, 3], f, side = 2)
    v[, 4] <- filter(v[, 4], f, side = 2)
    v <- v[(-N):-(N-n/2), ]
    v <- v[(-1):-(n/2), ]
    return (v)
}

cross <- function(a, b){
    return (c(a[2] * b[3] - a[3] * b[2],
              a[3] * b[1] - a[1] * b[3],
              a[1] * b[2] - a[2] * b[1]))
}

getRotationMatrixFromVector <- function(yaw, pitch, roll){
    ret <- diag(3)
    yawRotation <- matrix(c(cos(yaw), -sin(yaw), 0,
                            sin(yaw), cos(yaw), 0,
                            0, 0, 1), nrow = 3, ncol = 3, byrow = TRUE)
    pitchRotation <- matrix(c(cos(pitch), 0, sin(pitch),
                              0, 1, 0,
                              -sin(pitch), 0, cos(pitch)), nrow = 3, ncol = 3, byrow = TRUE)
    rollRotation <- matrix(c(1, 0, 0,
                             0, cos(roll), -sin(roll),
                             0, sin(roll), cos(roll)), nrow = 3, ncol = 3, byrow = TRUE)
    ret <- yawRotation %*% pitchRotation %*% rollRotation %*% ret
    return (ret)
}

# need to confirm
getVectorFromRoationMatrix <- function(rotationMatrix){
    roll <- atan2(rotationMatrix[3, 2], rotationMatrix[3, 3])
    pitch <- atan2(-rotationMatrix[3, 1], rotationMatrix[3, 2] / sin(roll))
    yaw <- atan2(rotationMatrix[2, 1], rotationMatrix[1, 1])
    return (c(roll, pitch, yaw))
}

# Fusion Parameter
FILTER_COEF <- 0.98

acc <- read.table("Acc.txt", sep = ",")
gyr <- read.table("Gyr.txt", sep = ",")
mag <- read.table("Mag.txt", sep = ",")

names(acc) <- c("Time", "x", "y", "z")
names(gyr) <- c("Time", "x", "y", "z")
names(mag) <- c("Time", "x", "y", "z")

acc$Time <- acc$Time - acc$Time[1]
gyr$Time <- gyr$Time - gyr$Time[1]
mag$Time <- mag$Time - mag$Time[1]

# acc in earth frame: x, y, z
# carAzimuth is car heading
accE <- data.frame(Time = numeric(0), x = numeric(0), y = numeric(0), z = numeric(0), carAzimuth = numeric(0))

t <- 1

gyroMatrix <- diag(3)

N <- nrow(acc)

# transStoE
for(t in 1:(N-1)){
    
    # find min of the length between [st, end]
    st = 1;
    end = t;
    if(t - 200 >= 1)st = t - 200  
    minValue = min(sqrt(acc[st:end,2]^2+acc[st:end,3]^2+acc[st:end,4]^2))
    idx = which(sqrt(acc[st:end,2]^2+acc[st:end,3]^2+acc[st:end,4]^2) == minValue) + st
    
    G <- acc[idx, 2:4]
    
    # c is gravity (point to down)
    # b is east
    # a is north
    c <- as.numeric(G / sqrt(sum(G^2)))
    b <- as.numeric(cross(c, mag[t, 2:4] / sqrt(sum(mag[t, 2:4]^2))))
    b <- b / sqrt(sum(b^2))
    a <- as.numeric(cross(b, c))
    a <- a / sqrt(sum(a^2))
    
    if(t == 1){
        tranStoE <- matrix(c(a,b,c), nrow = 3, ncol = 3)
        tranStoE <- solve(tranStoE)
    }
    
    buff <- rep(0, 5)
    buff[1] <- acc$Time[t]
    buff[2:4] <- tranStoE %*% (as.numeric(acc[t, 2:4]) - as.numeric(G))
    
    # acc, mag: azimuth, pitch, roll
    pitch <- -atan2(sqrt(c[2]^2 + c[3]^2), c[1])
    roll <- -atan2(sqrt(c[1]^2 + c[3]^2), c[2])
    if(abs(roll * 180 / pi) <= 100 && abs(roll * 180 / pi) >= 80){
        azimuth <- (360 + atan2(a[1], b[1]) * 180 / pi - 90) %% 360
    } else{
        azimuth <- (360 + atan2(a[2], b[2]) * 180 / pi) %% 360
    }
    azimuth <- azimuth / 180 * pi
    accMagOrientationVector <- c(roll, pitch, azimuth)
    
    if(t == 1){
        accMagOrientation <- getRotationMatrixFromVector(azimuth, pitch, roll)
        gyroMatrix <- accMagOrientation
    }
    
    # gyro
    # TODO:
    # use integration to calculate diff.
    
    gyroOrientationVector <- gyr[t, 2:4] * (gyr$Time[t + 1] - gyr$Time[t]) / 1000
    gyroOrientation <- getRotationMatrixFromVector(gyroOrientationVector$z, gyroOrientationVector$y, gyroOrientationVector$x)
    
    if(sqrt(sum(gyroOrientationVector^2)) > 0.0001){
        tranStoNextS <- gyroOrientation
        tranStoE <- tranStoNextS %*% tranStoE
    }
    
    gyroMatrix <- gyroOrientation %*% gyroMatrix
    gyroVector <- getVectorFromRoationMatrix(gyroMatrix)
    fusedOrientationVector <- FILTER_COEF * gyroVector + (1 - FILTER_COEF) * accMagOrientationVector
    gyroMatrix <- getRotationMatrixFromVector(fusedOrientationVector[3], fusedOrientationVector[2], fusedOrientationVector[1])
    
    # fusedOrientationVector <- tranStoE %*% fusedOrientationVector
    
    buff[5] <- fusedOrientationVector[3] * 180 / pi
    
    accE[nrow(accE) + 1, ] <- buff
}
