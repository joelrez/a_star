library(MASS)
library(purrr)
library(magrittr)
library(dplyr)
library(plotly)

start <- data.frame(x = 0, y = 0)

nodes <- as.data.frame(mvrnorm(n = 100, mu = c(2,2), Sigma = matrix(c(2, 0, 0, 3), ncol = 2))) %>%
          rename(x = V1, y = V2) %>%
          mutate(id = 1:nrow(.))

end <- data.frame(x = 4, y = 4.5, id = -1)




#unitnorm_to_end <- 

unitize <- function(vec){
  vec <- as.numeric(vec)
  vec/norm(matrix(vec), "F")
}

A_Star <- function(cur, maxDist = 3, Sum = 0){
  # browser()
  diffvec_cur_end_unit <- unitize(end %>% select(x,y) - cur)
  
  nodeList <- nodes %>% add_row(end) %>% mutate(dot = unlist(map2(x,y, function(x,y){
      diffvec_cur_node_unit <- unitize(c(x,y) - cur)
      
      diffvec_cur_node_unit %*% diffvec_cur_end_unit
  })),
  dist_node_end = unlist(map2(x,y, function(x,y){
    norm(matrix(as.numeric(end %>% select(x,y) - c(x,y))), "F")
  })),
  dist_cur_node = unlist(map2(x,y, function(x,y){
    norm(matrix(as.numeric(c(x,y) - cur)), "F")
  })),
  invdot = 1/2^dot,
  h = invdot + dist_node_end,
  f = dist_cur_node + h
  )
  
  
  result <- nodeList %>% filter(dist_cur_node <= maxDist, dist_cur_node > 0) %>% filter(f == min(f))
  if (nrow(result) == 0){
    print("Couldn't find the next node")
    return(NA)
  } else if (result$id == -1){
    Sum = Sum + result$dist_cur_node
    print("Done")
    print(paste0("Final sum ", Sum))
    return(result$id)
  } else {
    Sum = Sum + result$dist_cur_node
    print(paste0("Visiting node ", result$id))
    print(paste0("Current sum ", Sum))
    return(c(result$id, A_Star(result %>% select(x,y), Sum = Sum)))
  }
}

visitedNodes <- c(NA,A_Star(start))
nodeList <- start %>% mutate(id = NA) %>% add_row(nodes) %>% add_row(end)

plt <- ggplot() + geom_point(data = nodes, aes(x,y), color = 'red') + geom_point(data = start, aes(x,y), color = 'blue') + 
  geom_point(data = end, aes(x,y), color = 'purple') +
  geom_line(data = nodeList[match(visitedNodes, nodeList$id),], aes(x,y), color = "gold")

ggplotly( plt
)
