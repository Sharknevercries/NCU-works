source("accE.R")
source("GPS.R")

acc <- read.table("Acc.txt", sep = ",")
gyr <- read.table("Gyr.txt", sep = ",")
mag <- read.table("Mag.txt", sep = ",")
gps <- read.table("GPS.txt", sep = ",")

names(acc) <- c("Time", "x", "y", "z")
names(gyr) <- c("Time", "x", "y", "z")
names(mag) <- c("Time", "x", "y", "z")

##############################################################################

accE <- calculateACCE(acc, gyr, mag)
recordACCE(accE)

##############################################################################

TM2 <- calculateTM2(gps)
recordTM2(TM2)

##############################################################################

# after accE, TM2 generated
source("PF.R")

##############################################################################

TM2 <- read.table("TM2.txt", header = TRUE)
TM2 <- TM2[,-5]
# moving avg for coordinate
N1 <- 5 # for curvature
N2 <- 3 # for velocity
# format: time, x, y, curvature
curvature <- TM2
# format: time, x, y, velocity
velocity <- TM2

curvature[, 2:3] <- filter(curvature[, 2:3], filterWithPrevN(N1), side = 2)
velocity[, 2:3] <- filter(velocity[, 2:3], filterWithPrevN(N2), side = 2)

curvature <- calculateCurvature(curvature)
recordCurvature(curvature)
velocity <- calculateVelocity(velocity)
recordVelocity(velocity)

###############################################################################

# read road GPS data(curvature)
curvature <- read.table("curvature.txt", sep = " ", header = TRUE)
velocity <- read.table("velocity.txt", sep = " ", header = TRUE)
roadData <- read.csv(file = "GPS3_cur.txt", header = FALSE)
curvature[, 4] <- curvature[, 4] - roadData[, 4]

threshold <- 0.02

curvature[, 1] <- curvature[, 1] - curvature[1, 1]
velocity[, 1] <- velocity[, 1] - velocity[1, 1]
xmax <- 120

plot(velocity[, 1] / 1000, velocity[, 4], main = "速度/曲率", xlab = "Time(s)", ylab = "km / hr", ylim = c(5, 70), type = "l", lty = 3, xlim = c(0, xmax))
abline(h = 15, col = "green")
par(new = TRUE)
plot(curvature[, 1] / 1000, curvature[, 4], ylim = c(-0.2, 0.2), xaxt = "n", yaxt = "n", xlab = "", ylab = "", type = "o", pch = 1, lty = 1, xlim = c(0, xmax))
abline(h = threshold, col = "red")
axis(4)

# plot particles prediction df
p <- read.table("predict2.txt")
p[, 2:3] <- filter(p[, 2:3], filterWithPrevN(9), sides = 2)
p <- calculateCurvature(p)
p[, 4] <- p[, 4] - roadData[, 4]
p[, 4] <- filter(p[, 4], filterWithPrevN(9), sides = 2)
par(new = TRUE)
plot(p[, 1] / 1000, p[, 4], ylim = c(-0.2, 0.2), xaxt = "n", yaxt = "n", xlab = "", ylab = "", type = "o", pch = 2, lty = 1, xlim = c(0, xmax)) 

gps <- read.table("1108_1738highGPS.txt", header = FALSE)

# start from TM2

par(new = TRUE)
plot(curvature[, 1], curvature[, 4], ylim = c(-0.2, 0.2), xaxt = "n", yaxt = "n", xlab = "", ylab = "", type = "o", pch = 4, lty = 1, xlim = c(0, xmax))

#legend("topright", c("速率", "GPS曲率差", "PF曲率差", "高精準GPS曲率差"), lty = c(3, 1, 1, 1), pch = c(-1, 1, 2, 3), cex = 0.5)
# 1 circle
# 2 triangle
# 4 X

getThresholdTime <- function(curvature){
    ret <- c()
    N <- nrow(curvature)
    for(i in 1:(N-1)){
        if(!is.na(curvature[i, 4]) && !is.na(curvature[i + 1, 4]) && curvature[i, 4] <= threshold && threshold <= curvature[i + 1, 4]){
            curPerSec <- (curvature[i + 1, 4] - curvature[i, 4]) / (curvature[i + 1, 1] - curvature[i, 1])
            ret <- c(ret, (threshold - curvature[i, 4]) / curPerSec + curvature[i, 1])
        }
    }
    return (ret)
}

GPSReach <- getThresholdTime(curvature) / 1000
PFReach <- getThresholdTime(p) / 1000

