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