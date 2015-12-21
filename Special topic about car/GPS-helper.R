WGS84toTWD97 <- function(lat, lon){
    
    a <- 6378137.0
    b <- 6356752.34245
    longo <- 121/180*pi
    k0 <- 0.9999
    dx <- 250000
    
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

filterWithPrevN <- function(N = 1){
    
    return (c(rep(1 / as.integer(N / 2 + 1), N / 2 + 1), rep(0, N / 2)))
    
}