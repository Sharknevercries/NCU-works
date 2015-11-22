# Smooth the data
# param
#   v:  data in format such c(Time, x, y, z)
#   n:  smooth range.

movingAverage <- function(v){
    n <- 101
    N <- nrow(v)
    f <- rep(1 / n, n)
    v[, 2] <- filter(v[, 2], f, side = 2)
    v[, 3] <- filter(v[, 3], f, side = 2)
    v[, 4] <- filter(v[, 4], f, side = 2)
    v <- v[(-N):-(N-n/2), ]
    v <- v[(-1):-(n/2), ]
    return (v)
}

# Cross product
cross <- function(a, b){
    return (c(a[2] * b[3] - a[3] * b[2],
              a[3] * b[1] - a[1] * b[3],
              a[1] * b[2] - a[2] * b[1]))
}

######################################################################
#
# Google Git Source Code
#
#   https://android.googlesource.com/platform/frameworks/base/+/cd92588/core/java/android/hardware/SensorManager.java
#
######################################################################


getRotationMatrix <- function(gravity, geomanetic){
    A <- gravity
    E <- geomanetic
    H <- cross(E, A)
    normH <- sqrt(sum(H^2))
    normA <- sqrt(sum(A^2))
    if(normH < 0.1){
        return (FALSE)
    }
    H <- H / normH
    A <- A / normA
    M <- cross(A, H)
    R <- matrix(c(H, M, A),nrow = 3, ncol = 3, byrow = TRUE)
    return (R)
}

getOrientation <- function(R){
    values <- rep(0, 3)
    values[1] <- atan2(R[1, 2], R[2, 2])
    values[2] <- asin(-R[3, 2])
    values[3] <- atan2(-R[3, 1], R[3, 3])
    return (values)
}

getRotationVectorFromGyro <- function(gyro, timeFactor){
    magnitude <- sqrt(sum(gyro^2))
    normValues <- rep(0, 3)
    if(magnitude > 0.00000001){
        normValues <- gyro / magnitude
    }
    thetaOverTwo <- magnitude * timeFactor
    sinThetaOverTwo <- sin(thetaOverTwo)
    cosThetaOverTwo <- cos(thetaOverTwo)
    return (c(sinThetaOverTwo * normValues, cosThetaOverTwo))
}

getRotationMatrixFromOrientation <- function(A){
    sinX <- sin(A[2])
    cosX <- cos(A[2])
    sinY <- sin(A[3])
    cosY <- cos(A[3])
    sinZ <- sin(A[1])
    cosZ <- cos(A[1])
    xM <- matrix(c(1, 0, 0,
                   0, cosX, sinX,
                   0, -sinX, cosX), nrow = 3, ncol = 3, byrow = TRUE)
    yM <- matrix(c(cosY, 0, sinY,
                   0, 1, 0,
                   -sinY, 0, cosY), nrow = 3, ncol = 3, byrow = TRUE)
    zM <- matrix(c(cosZ, sinZ, 0,
                   -sinZ, cosZ, 0,
                   0, 0, 1), nrow = 3, ncol = 3, byrow = TRUE)
    return (zM %*% (xM %*% yM))
}

getRotationMatrixFromVector <- function(v){
    q0 <- 0
    q1 <- v[1]
    q2 <- v[2]
    q3 <- v[3]
    if(length(v) == 4){
        q0 <- v[4]
    } else {
        q0 <- 1 - (sum(v^2))
        if(q0 > 0)
            q0 <- sqrt(q0)
        else
            q0 <- 0
    }
    sq_q1 <- 2 * q1 * q1
    sq_q2 <- 2 * q2 * q2
    sq_q3 <- 2 * q3 * q3
    q1_q2 <- 2 * q1 * q2
    q3_q0 <- 2 * q3 * q0
    q1_q3 <- 2 * q1 * q3
    q2_q0 <- 2 * q2 * q0;
    q2_q3 <- 2 * q2 * q3;
    q1_q0 <- 2 * q1 * q0;
    
    R <- matrix(c(1 - sq_q2 - sq_q3, q1_q2 - q3_q0, q1_q3 + q2_q0,
                  q1_q2 + q3_q0, 1 - sq_q1 - sq_q3, q2_q3 - q1_q0,
                  q1_q3 - q2_q0, q2_q3 + q1_q0, 1 - sq_q1 - sq_q2), nrow = 3, ncol = 3, byrow = TRUE)
    return (R)
}

function(){
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
        ret <- ret %*% yawRotation %*% pitchRotation %*% rollRotation
        return (ret)
    }
}
