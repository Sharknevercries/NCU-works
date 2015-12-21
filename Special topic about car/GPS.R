source("GPS-helper.R")

# Convert GPS latitude and longitude into grid coordinate.
calculateTM2 <- function(GPSData){
    
    data <- GPSData[,2:3]
    names(data) = c("lat","long")
    
    # get TM2 xy-coord (m)
    n <- nrow(data)
    TM2 <- array(dim=c(n, 5))
    TM2[, 1] <- GPSData[, 1]
    for(i in 1:n) 
        TM2[i,3:2] <- WGS84toTWD97(data[i,1], data[i,2]) # Latitude => y, longtitude => x
    
    colnames(TM2) <- c("Time", "x", "y", "speed", "heading")
    return (TM2)
    
}

recordTM2 <- function(TM2){
    
    write.table(TM2, file = "TM2.txt", col.names = TRUE, row.names = FALSE)
    
}

########################################################################

calculateCurvature <- function(curvature){
    
    n <- nrow(curvature)
    for(i in 2:(n-1)){
        a <- ((curvature[i - 1, 2] - curvature[i, 2])^2+(curvature[i - 1, 3] - curvature[i, 3])^2)^0.5
        b <- ((curvature[i, 2] - curvature[i + 1, 2])^2+(curvature[i, 3] - curvature[i + 1, 3])^2)^0.5
        c <- ((curvature[i - 1, 2] - curvature[i + 1, 2])^2+(curvature[i - 1, 3] - curvature[i + 1, 3])^2)^0.5
        theta <- (a^2 + b^2 - c^2) / (2 * a * b)
        curvature[i, 4] <- 1 / (c / (2 * (1 - theta^2)) ^ 0.5)
        # make cross to check direction whether it is left or right
        if(!is.na(curvature[i, 4])){
            x1 <- curvature[i, 2] - curvature[i - 1, 2]
            x2 <- curvature[i + 1, 2] - curvature[i, 2]
            y1 <- curvature[i, 3] - curvature[i - 1, 3]
            y2 <- curvature[i + 1, 3] - curvature[i, 3]
            if(x1 * y2 - x2 * y1 > 0){
                curvature[i, 4] <- curvature[i, 4] * -1
            }
        }
    }
    return (curvature)
    
}

recordCurvature <- function(curvature){
    
    curvature <- as.data.frame(curvature)
    names(curvature) <- c("Time", "x", "y", "curvature")
    write.table(curvature, file = "curvature.txt", col.names = TRUE, row.names = FALSE)
    
}

#########################################################################

calculateVelocity <- function(velocity, gapN = 1){
    
    n <- nrow(velocity)
    for(i in 1:n){
        L <- as.integer(i - gapN / 2)
        R <- as.integer(i + gapN / 2)
        if(L < 1)   L <- 1
        if(R > n)   R <- n
        # km / s
        vx <- (velocity[R, 2] - velocity[L, 2]) / 1000 
        vy <- (velocity[R, 3] - velocity[L, 3]) / 1000
        # km / hr
        velocity[i, 4] <- (sqrt(vx^2+vy^2) / gapN) * 3600
    }
    return (velocity)
    
}

recordVelocity <- function(velocity){
    
    velocity <- as.data.frame(velocity)
    names(velocity) <- c("Time", "x", "y", "speed") 
    write.table(curvature, file = "curvature.txt", col.names = TRUE, row.names = FALSE)
    
}

##################################################################################