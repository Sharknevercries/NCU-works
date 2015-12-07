# read GPS WGS84 
originData = read.table("GPS.txt", sep=",")
data <- originData[,2:3]
names(data) = c("lat","long")

# convert WGS84 to TWD97
a <- 6378137.0
b <- 6356752.34245
longo <- 121/180*pi
k0 <- 0.9999
dx <- 250000
WGS84toTWD97 <- function(lat, lon){
    lat = lat/180*pi
    lon = lon/180*pi
    
    e = (1-b**2/a**2)**0.5
    e2 = e**2/(1-e**2)
    n = (a-b)/(a+b)
    nu = a/(1-e**2*sin(lat)**2)**0.5
    p = lon-longo
    
    A = a*(1 - n + (5/4.0)*(n**2 - n**3) + (81/64.0)*(n**4  - n**5))
    B = (3*a*n/2.0)*(1 - n + (7/8.0)*(n**2 - n**3) + (55/64.0)*(n**4 - n**5))
    C = (15*a*(n**2)/16.0)*(1 - n + (3/4.0)*(n**2 - n**3))
    D = (35*a*(n**3)/48.0)*(1 - n + (11/16.0)*(n**2 - n**3))
    E = (315*a*(n**4)/51.0)*(1 - n)
    
    S = A*lat - B*sin(2*lat) + C*sin(4*lat) - D*sin(6*lat) + E*sin(8*lat)
    
    K1 = S*k0
    K2 = k0*nu*sin(2*lat)/4.0
    K3 = (k0*nu*sin(lat)*(cos(lat)**3)/24.0) * 
        (5 - tan(lat)**2 + 9*e2*(cos(lat)**2) + 4*(e2**2)*(cos(lat)**4))
    
    y = K1 + K2*(p**2) + K3*(p**4)
    
    K4 = k0*nu*cos(lat)
    K5 = (k0*nu*(cos(lat)**3)/6.0) * 
        (1 - tan(lat)**2 + e2*(cos(lat)**2))
    
    x = K4*p + K5*(p**3) + dx
    return(c(x, y))
}

# get TM2 xy-coord (m)
n <- nrow(data)
TM2 <- array(dim=c(n, 5))
TM2[, 1] <- originData[, 1]
TM2[, 4] <- originData$V5
TM2[, 5] <- originData$V6
for(i in 1:n) 
    TM2[i,3:2] <- WGS84toTWD97(data[i,1], data[i,2]) # Latitude => y, longtitude => x

colnames(TM2) <- c("time", "x", "y", "speed", "heading")
write.table(TM2, file = "TM2.txt", col.names = TRUE, row.names = FALSE)

# moving avg for coordinate
N1 <- 5 # for curvature
N2 <- 3 # for velocity
gapN <- 1 # velocity sample gap
# format: time, x, y, curvature
curvature <- TM2
# format: time, x, y, velocity
velocity <- TM2
curvature[, 2:3] <- filter(curvature[, 2:3], rep(1 / N1, N1), side = 2)
velocity[, 2:3] <- filter(velocity[, 2:3], rep(1 / N2, N2), side = 2)

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
        if(x1 * y2 - x2 * y1 < 0){
            curvature[i, 4] <- curvature[i, 4] * -1
        }
    }
}
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

curvature <- as.data.frame(curvature)
names(curvature) <- c("Time", "x", "y", "?›²???")
write.table(curvature, file = "curvature.txt", col.names = TRUE, row.names = FALSE)
velocity <- as.data.frame(velocity)
names(velocity) <- c("Time", "x", "y", "?€Ÿç??") 
write.table(velocity, file = "velocity.txt", col.names = TRUE, row.names = FALSE)

# read road GPS data(curvature)
roadData <- read.csv(file = "GPS1set.csv", header = FALSE)
dfCurvature <- curvature[, 4] - roadData[, 4]
dfCurvature <- filter(curvature[,4], rep(1 / N1, N1), side = 2)

# plot GPSout
curvature <- read.table("curvature.txt", sep = " ", header = TRUE)
velocity <-read.table("velocity.txt", sep = " ", header = TRUE)
n <- nrow(curvature)

threshold <- 0.02

plot(velocity[, 1], dfCurvature, main = paste("?›²??‡å·®??‡åŸºæº–ç??", threshold, sep = " "), xlab = "Time(s)", ylab = "?›²???", ylim = c(-0.4,0.4), type = "l", lty = 1)
par(new = TRUE)

# plot threshold
abline(h = threshold, col = "red")
legend("topright", c("?›²??‡å·®", paste("??ƒè€ƒåŸºæº–å€?", threshold, sep = " ")), col = c("black", "red"), lty = 1)

#plot(curvature[,1], roadData[,4], type = "l", col = "red", ylim = c(-0.4,0.4), xaxt = "n", yaxt = "n", xlab = "", ylab = "")
#par(new = TRUE)
#plot(curvature[,1], dfCurvature, type = "l", col = "blue", ylim = c(0,0.4), xaxt = "n", yaxt = "n", xlab = "", ylab = "")
axis(side = 1, at = seq(0, 500, by = 25))
#legend("topright", c("?€Ÿç??","Car?›²???","df?›²???"), col = c("black","red","blue"), lty = 1)
legend("topright", c("è»Šæ›²???","??“è·¯?›²???"), col = c("black","red"), lty = 1)
