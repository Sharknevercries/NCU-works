# functions
## format: x, y
## Place particles near GPS point, which distance <= GPS_EPS
randomPosition <- function(idx, n) {
    pos <- matrix(nrow = n, ncol = 2)
    colnames(pos) <- c("x", "y")
    angle <- runif(n, 0, 2 * pi)
    magnitude <- runif(n, 0, GPS_EPS)
    pos[1:n, 1] <- GPS_DATA[idx, 2] + magnitude * cos(angle)
    pos[1:n, 2] <- GPS_DATA[idx, 3] + magnitude * sin(angle)
    return(pos)
}

# move particles by ACC_DATA
## particles: as name.
## idx: ACC_DATA's index
## n: total size of the particles
## timeEclipse: millisec passed
moveParticles <- function(particles, idx, n, timeEclipse){
    
    # ACC_DATA azimuth is degree. Change it to radius
    # the coordinate system must be changed too.
    # azimuth 0 degree point to the north.
    
    timeEclipse <- timeEclipse / 1000
    magnitude <- ACC_DATA$magnitude[idx]
    theta <- parseAzimuth(ACC_DATA$azimuth[idx]) / 180 * pi + runif(n, min = -ANG_EPS, max = ANG_EPS)
    rand_magnitude <- magnitude + magnitude * runif(n, min = -ACC_EPS, max = ACC_EPS)
    rand_acc <- matrix(nrow = n, ncol = 2)
    colnames(rand_acc) <- c("x", "y")
    rand_acc[, "x"] <- cos(theta) * rand_magnitude
    rand_acc[, "y"] <- sin(theta) * rand_magnitude
    
    particles[, "x"] <- particles[, "x"] + (2 * particles[, "vx"] + rand_acc[, "x"]) * timeEclipse / 2
    particles[, "y"] <- particles[, "y"] + (2 * particles[, "vy"] + rand_acc[, "y"]) * timeEclipse / 2
    particles[, "vx"] <- particles[, "vx"] + rand_acc[, "x"] * timeEclipse
    particles[, "vy"] <- particles[, "vy"] + rand_acc[, "y"] * timeEclipse
        
    return (particles)
}

parseAzimuth <- function(azimuth){
    theta <- azimuth
    if(theta <= 0){
        theta <- (-theta) + 90
    }else if(theta <= 90){
        theta <- 90 - theta
    }else{
        theta <- theta - 90
    }
    return (theta)
}

#
# Particle Filters(SIR)
#

# constants
MAX_SIZE <- 500 # number of particles
GPS_EPS <- 5 # meter, circle area
ACC_EPS <- 0.10 # 100 %
ANG_EPS <- pi / 3 # +- 60 degree
ATTEN <- 0.5

# getData
GPS_DATA <- read.table("TM2.txt", header = TRUE)
ACC_DATA <- read.table("accE.txt", header = TRUE)
timeBase <- GPS_DATA$Time[1]
GPS_DATA$Time <- GPS_DATA$Time - (GPS_DATA$Time[1] - timeBase %% 1000)
ACC_DATA$Time <- ACC_DATA$Time - (ACC_DATA$Time[1] - timeBase %% 1000)
nrowOfACC_DATA <- nrow(ACC_DATA)
nrowOfGPS_DATA <- nrow(GPS_DATA)

# initilize
particles <- matrix(nrow = MAX_SIZE, ncol = 5)
colnames(particles) <- c("x", "y", "vx", "vy", "weight")
particles[, c("x", "y")] <- randomPosition(1, MAX_SIZE)
particles[, c("vx", "vy")] <- rep(0, MAX_SIZE)
particles[, "weight"] <- rep(1 / MAX_SIZE, MAX_SIZE)

CDF <- array(dim = MAX_SIZE)
approPos <- c(sum(particles[, "x"]) / MAX_SIZE, sum(particles[, "y"]) / MAX_SIZE)
curTimeStamp <- GPS_DATA$Time[1]
GPSIndex <- 2
startIndex <- 1

while(ACC_DATA$Time[startIndex] <= curTimeStamp){
    startIndex <- startIndex + 1
}

ret <- data.frame(Time = numeric(0), x = numeric(0), y = numeric(0), eff = numeric(0))

# start particle filter

for(i in startIndex:(nrowOfACC_DATA - 1)){
    
    # use GPS observation, this is NOT particle filter.
    effCount <- MAX_SIZE
    if(GPSIndex <= nrowOfGPS_DATA && ACC_DATA$Time[i] > GPS_DATA$Time[GPSIndex]){
      particles <- moveParticles(particles, i, MAX_SIZE, GPS_DATA$Time[GPSIndex] - curTimeStamp)
      curTimeStamp <- GPS_DATA$Time[GPSIndex] 
      
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
    
    # predict position
    approPos <- c(sum(particles[, "x"]) / MAX_SIZE, sum(particles[, "y"]) / MAX_SIZE)
    print(approPos)
    #buff <- rep(0, 3)
    #buff[1] <- ACC_DATA$Time[i]
    #buff[2:3] <- approPos
    #buff[4] <- 1
    
    #ret[nrow(ret) + 1, ] <- buff
    
    # supply up to MAX_SIZE by replicating effective paricles with uniform distribution
    
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
}