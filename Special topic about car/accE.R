source("accE-helper.R", chdir = TRUE)

calculateACCE <- function(acc, gyr, mag, FILTER_COEF = 0.99, SHIFT_NUM = 500){

    # acc in earth frame: x, y, z
    # carAzimuth is car heading
    accE <- data.frame(Time = numeric(0), x = numeric(0), y = numeric(0), z = numeric(0), azimuth = numeric(0), pitch = numeric(0), roll = numeric(0), magnitude = numeric(0))
    
    t <- 1
    
    gyroMatrix <- diag(3)
    
    N <- nrow(acc)
    
    # transStoE
    for(t in 1:(N-1)){
        
        st = 1;
        end = t;
        if(t - SHIFT_NUM >= 1)st = t - SHIFT_NUM
        if((end - st + 1) %% 2 == 0) st <- st + 1
        minValue = min(sqrt(acc[st:end,2]^2+acc[st:end,3]^2+acc[st:end,4]^2))
        idx = which(sqrt(acc[st:end,2]^2+acc[st:end,3]^2+acc[st:end,4]^2) == minValue) + st
    
        G <- as.numeric(acc[idx, 2:4])
        
        rotationMatrix <- getRotationMatrix(G, as.numeric(mag[t, 2:4]))
        accMagOrientation <- getOrientation(rotationMatrix)
        
        if(t == 1){
            initMatrix <- getRotationMatrixFromOrientation(accMagOrientation)
            gyroMatrix <- gyroMatrix %*% initMatrix
            gyroOrientation <- getOrientation(gyroMatrix)
        }
        
        buff <- rep(0, 5)
        buff[1] <- acc$Time[t]
        buff[2:4] <- gyroMatrix %*% as.numeric(acc[t, 2:4] - G)
        buff[5:7] <- gyroOrientation * 180 / pi
        buff[8] <- sqrt(sum(buff[2:3]^2))
        
        accE[nrow(accE) + 1, ] <- buff
        
        dT <- (acc$Time[t + 1] - acc$Time[t]) / 1000 # ms to s
        deltaVector <- getRotationVectorFromGyro(as.numeric(gyr[t, 2:4]), dT / 2)
        deltaMatrix <- getRotationMatrixFromVector(deltaVector)
        gyroMatrix <- gyroMatrix %*% deltaMatrix
        gyroOrientation <- getOrientation(gyroMatrix)
        
        fusedOrientation <- rep(0, 3)
        for(i in 1:3){
            if (gyroOrientation[i] < -0.5 * pi && accMagOrientation[i] > 0.0) {
                fusedOrientation[i] <- FILTER_COEF * (gyroOrientation[i] + 2.0 * pi) + (1 - FILTER_COEF) * accMagOrientation[i]
                if(fusedOrientation[i] > pi)
                    fusedOrientation[i] <- fusedOrientation[i] - 2.0 * pi
            }
            else if (accMagOrientation[i] < -0.5 * pi && gyroOrientation[i] > 0.0) {
                fusedOrientation[i] = FILTER_COEF * gyroOrientation[i] + (1 - FILTER_COEF) * (accMagOrientation[i] + 2.0 * pi)
                if(fusedOrientation[i] > pi)
                    fusedOrientation[i] <- fusedOrientation[i] - 2.0 * pi
            }
            else {
                fusedOrientation[i] = FILTER_COEF * gyroOrientation[i] + (1 - FILTER_COEF) * accMagOrientation[i];
            }
        }
        
        gyroMatrix <- getRotationMatrixFromOrientation(fusedOrientation)
        gyroOrientation <- fusedOrientation
        
    }
    
    return (accE);

}

recordACCE <- function(accE){
    
    write.table(accE, file = "accE.txt", col.names = TRUE, row.names = FALSE)
    
}
