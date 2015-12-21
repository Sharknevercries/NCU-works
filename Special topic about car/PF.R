source("PF-helper.R")

#
# Particle Filters(SIR)
#

# constants
MAX_SIZE <- 2000 # number of particles
GPS_EPS <- 5 # meter, circle area
ACC_EPS <- 0.30 # 100 %
ANG_EPS <- pi / 3 # +- 60 degree
ATTEN <- 0.75

# getData
GPS_DATA <- read.table("TM2.txt", header = TRUE)
ACC_DATA <- read.table("accE.txt", header = TRUE)
timeBase <- GPS_DATA$Time[1]
GPS_DATA$Time <- GPS_DATA$Time - (GPS_DATA$Time[1] - timeBase %% 1000)
ACC_DATA$Time <- ACC_DATA$Time - (ACC_DATA$Time[1] - timeBase %% 1000)
nrowOfACC_DATA <- nrow(ACC_DATA)
nrowOfGPS_DATA <- nrow(GPS_DATA)

# initilize
ret1 <- matrix(nrow = nrow(GPS_DATA), ncol = 4) # predict after using GPS
ret2 <- matrix(nrow = nrow(GPS_DATA), ncol = 4) # predict before using GPS
particles <- matrix(nrow = MAX_SIZE, ncol = 5)
colnames(particles) <- c("x", "y", "vx", "vy", "weight")
particles[, c("x", "y")] <- randomPosition(1, MAX_SIZE)
particles[, c("vx", "vy")] <- rep(0, MAX_SIZE)
particles[, "weight"] <- rep(1 / MAX_SIZE, MAX_SIZE)

CDF <- array(dim = MAX_SIZE)
approPos <- c(sum(particles[, "x"]) / MAX_SIZE, sum(particles[, "y"]) / MAX_SIZE)
ret1[, 1] <- GPS_DATA$Time
ret1[1, 2:3] <- approPos
ret2[, 1] <- GPS_DATA$Time
ret2[1, 2:3] <- approPos

curTimeStamp <- GPS_DATA$Time[1]
GPSIndex <- 2
startIndex <- 1

while(ACC_DATA$Time[startIndex] <= curTimeStamp){
    startIndex <- startIndex + 1
}

# start particle filter

for(i in startIndex:(nrowOfACC_DATA - 1)){
    
    # use GPS observation, this is NOT particle filter.
    if(GPSIndex <= nrowOfGPS_DATA && ACC_DATA$Time[i] > GPS_DATA$Time[GPSIndex]){
      particles <- moveParticles(particles, i, MAX_SIZE, GPS_DATA$Time[GPSIndex] - curTimeStamp)
      curTimeStamp <- GPS_DATA$Time[GPSIndex] 
      
      approPos <- c(sum(particles[, "x"]) / MAX_SIZE, sum(particles[, "y"]) / MAX_SIZE)
      ret2[GPSIndex, 2:3] <- approPos
      
      effParticles <- particles
      k <- 1
      for(j in 1:MAX_SIZE){
        effParticles[k, ] <- particles[j, ]
        # dispose of paritcles which are out of range 
        if(sqrt((particles[j, "x"] - GPS_DATA$x[GPSIndex])^2+(particles[j, "y"] - GPS_DATA$y[GPSIndex])^2) <= GPS_EPS){
          k <- k + 1
        }
      }
      effCount <- k
      # actually, the real count is effCount - 1.
      if(effCount > 1){
          while(k <= MAX_SIZE){
              target <- as.integer(runif(1, min = 1, max = effCount - 0.000001))
              effParticles[k, ] <- effParticles[target, ]
              k <- k + 1
          }
      }
      else{
          effParticles[, c("x", "y")] <- randomPosition(GPSIndex, MAX_SIZE)
          effParticles[, c("vx", "vy")] <- effParticles[, c("vx", "vy")] * ATTEN
      }
      # normalize
      weightSum <- sum(effParticles[, "weight"])
      effParticles[, "weight"] <- effParticles[, "weight"] / weightSum
      
      particles <- effParticles
      
      # predict position
      approPos <- c(sum(particles[, "x"]) / MAX_SIZE, sum(particles[, "y"]) / MAX_SIZE)
      ret1[GPSIndex, 2:3] <- approPos
      ret1[GPSIndex, 4] <- effCount
      
      GPSIndex <- GPSIndex + 1
    }
    
    particles <- moveParticles(particles, i, MAX_SIZE, ACC_DATA$Time[i] - curTimeStamp)
    curTimeStamp <- ACC_DATA$Time[i]
    #CDF <- seq(1 / MAX_SIZE, length.out = MAX_SIZE, by = 1 / MAX_SIZE)
    for(j in 1:MAX_SIZE){
        if(j == 1)
            CDF[j] <- particles[j, "weight"]
        else
            CDF[j] <- CDF[j - 1] + particles[j, "weight"]
    }
    
    # resample
    newParticles <- particles
    u <- runif(1, 0, 1 / MAX_SIZE)
    tmp <- rep(0, MAX_SIZE)
    k <- 1
    for(j in 1:MAX_SIZE){
        v <- u + (j - 1) * (1 / MAX_SIZE)
        while(v > CDF[k])
            k <- k + 1
        tmp[j] <- k
    }
    particles[1:MAX_SIZE, ] <- particles[tmp, ]
    particles[, "weight"] <- 1 / MAX_SIZE
    print(i)
}

# after GPS observation
write.table(ret1, file = "predict1.txt", col.names = FALSE, row.names = FALSE)
# before GPS observation
write.table(ret2, file = "predict2.txt", col.names = FALSE, row.names = FALSE)