#
# Particle Filters(SIR)
#

# constants
MAX_SIZE <- 10 # number of particles
GPS_EPS <- 5 # meter, circle area
ACC_EPS <- 0.05 # 100 %
ANG_EPS <- pi / 3 # +- 60 degree
GYR_EPS <- 0.05 # 100 %

# getData
GPS_DATA <- read.table("TM2.txt",header = TRUE)
ACC_DATA <- read.table("accE.txt", header = TRUE)
GPS_DATA$Time <- GPS_DATA$Time - (GPS_DATA$Time[1] - GPS_DATA$Time[1] %% 1000)
ACC_DATA$Time <- ACC_DATA$Time - (ACC_DATA$Time[1] - ACC_DATA$Time[1] %% 1000)
Time <- nrow(ACC_DATA)

# functions
## format: x, y
## Place particles near GPS point, which distance <= GPS_EPS
randomPosition <- function(idx, n) {
    pos <- matrix(nrow = n, ncol = 2)
    colnames(pos) <- c("x", "y")
    choose <- rep(1:n)
    len <- length(choose)
    while(sum(choose) > 0){
        pos[choose, 1] <- GPS_DATA$x[idx] + runif(len, -GPS_EPS, GPS_EPS)
        pos[choose, 2] <- GPS_DATA$y[idx] + runif(len, -GPS_EPS, GPS_EPS)
        choose <- which(sqrt((pos[choose, 1] - GPS_DATA$x[idx])^2 + (pos[choose, 2] - GPS_DATA$y[idx])^2) > GPS_EPS)
        len <- length(choose)
    } 
    return(pos)
}

# move particles by ACC_DATA
## particles: as name.
## idx: ACC_DATA's index
## n: total size of the particles
## timeEclipse: millisec passed
moveParticles <- function(particles, idx, n, timeEclipse){
    timeEclipse <- timeEclipse / 1000
    magnitude <- sqrt(ACC_DATA$x[idx]^2+ACC_DATA$y[idx]^2)
    for(j in 1:n){
        # x - north, y - east
        
        theta <- atan2(ACC_DATA$y[idx], ACC_DATA$x[idx]) + runif(1, min = -ANG_EPS, max = ANG_EPS)
        if(theta < 0)
          theta <- theta + 2 * pi
        
        print(theta)
        
        rand_magnitude <- magnitude + magnitude * runif(1, min = -ACC_EPS, max = ACC_EPS)
        rand_acc <- c(cos(theta) * rand_magnitude, sin(theta) * rand_magnitude)
        names(rand_acc) <- c("x", "y")
        
        particles$x[j] <- particles$x[j] + (2 * particles$vx[j] + rand_acc["x"]) * timeEclipse / 2
        particles$y[j] <- particles$y[j] + (2 * particles$vy[j] + rand_acc["y"]) * timeEclipse / 2
        particles$vx[j] <- particles$vx[j] + rand_acc["x"] * timeEclipse
        particles$vy[j] <- particles$vy[j] + rand_acc["y"] * timeEclipse
    }
    return (particles)
}

# initilize
pos <- randomPosition(1, MAX_SIZE)
vx <- rep(0, MAX_SIZE)
vy <- rep(0, MAX_SIZE)
# issue: how to retrive velocity distribution?
weight <- rep(1 / MAX_SIZE, MAX_SIZE)
CDF <- array(dim = MAX_SIZE)
particles <- data.frame(pos, vx, vy, weight)
approPos <- c(sum(particles$x) / MAX_SIZE, sum(particles$y) / MAX_SIZE)
GPSIndex <- 1
curTimeStamp <- ACC_DATA$Time[1]

# start particle filter
for(i in 1:(Time - 1)){
    # use GPS observation, this is NOT particle filter.
    if(ACC_DATA$Time[i + 1] > GPS_DATA$Time[GPSIndex] && GPSIndex <= row(GPS_DATA)){
      moveParticles(particles, i, MAX_SIZE, GPS_DATA$Time[GPSIndex] - curTimeStamp)
      curTimeStamp <- GPS_DATA$Time[GPSIndex]
      GPSIndex <- GPSIndex + 1
      
      effParticles <- particles
      k <- 1
      for(j in 1:MAX_SIZE){
        effParticles[k, ] <- particles[j, ]
        # dispose of paritcles which are out of range 
        if(sqrt((particles$x[j] - GPS_DATA[i,1])^2+(particles$y[j] - GPS_DATA[i,2])^2) <= GPS_EPS){
          k <- k + 1
        }
      }
      effCount <- k
      while(k <= MAX_SIZE){
          target <- as.integer(runif(1, min = 1, max = effCount - 0.000001))
          effParticles[k, ] <- effParticles[target, ]
          k <- k + 1
      }
      # normalize
      weightSum <- sum(effParticles$weight)
      effParticles$weight <- effParticles$weight / weightSum
      
      particles <- effParticles
    }
    
    particles <- moveParticles(particles, i, MAX_SIZE, ACC_DATA$Time[i + 1] - curTimeStamp)
    for(j in 1:MAX_SIZE){
        if(j == 1)
            CDF[j] <- particles$weight[j]
        else
            CDF[j] <- CDF[j - 1] + particles$weight[j]
    }
    
    # predict position
    approPos <- c(sum(particles$x) / MAX_SIZE, sum(particles$y) / MAX_SIZE)
    print(i)
    print(particles)
    print(approPos)
    
    # supply up to MAX_SIZE by replicating effective paricles with uniform distribution
    
    # resample
    newParticles <- particles
    u <- runif(1, 0, 1 / MAX_SIZE)
    k <- 1
    for(j in 1:MAX_SIZE){
        v <- u + (j - 1) * (1 / MAX_SIZE)
        while(v > CDF[k])
            k <- k + 1
        newParticles[j, ] <- particles[k, ]
    }
    newParticles$weight <- 1 / MAX_SIZE
    particles <- newParticles
    
}