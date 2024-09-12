# a_star
Maybe this is not A* necessarily, but takes inspiration from some ideas I've gleaned from A*.

Today, I wanted to learn the A* pathfinding algorithm. Reading the [wikipedia source](https://en.wikipedia.org/wiki/A*_search_algorithm) on the algorithm, I understand that the crux of the algorithm is minimizing some function that is to estimate how bad choosing to go to one node in a graph might be.

In the graph I wrote in R, there are no edges displayed because it is assumed that the agent can go to any node it wants so long as it is a node within the radius it can travel in one move. After finding the node ids to traverse, I visualize the results at the end. Gold lines indicating how the path was set.

A great part in how I understand the A* algorithm works is that it is minimizing an F score which is for a node n, F(n) = g(n) + h(n) where g(n) is the cost function, i.e., summing the weights of the previous edges. And h(n) is a problem-specific heuristic function which I had to think through.

For this case h(n) = dist_to_goal(n) + 1/2^(goal/|goal|,n/|n|) where (goal/|goal|,n/|n|) is the dot product of the unitized goal and n vectors. This metric allows us to give a penalty to the F score because travelling to the next node is not in the same direction as the goal state. 

I came up with this idea considering the basic properties of orthonormal vectors and inner products of unit vectors. As a reminder or new piece of information, if we have two distinct orthonormal basis vectors u and v, then the inner product <u,v> = 0. If it turns out that u = v, then <u,v> = 1. In the literature, the right hand side is substituted with the Kronecker Delta I will denote d(i,j). Then for two orthonormal vectors u(i) and u(j), <u(i),u(j)> = d(i,j) = { 0 if i != j otherwise 1. Pardon my notation, of course.

By the preceding paragraph, we can say that two unit vectors have the same direction if their dot product is close to 1. If it's not positive, then clearly the two vectors you're considering do not point in the same general direction. Now, we must minimize the F score, and it turns out the dot product in this case makes the global maximum, 1, the point when the unit vectors are exactly the same. We need to penalize for picking locations that aren't in the same direction as our goal state. Hence, I decided to attempt taking the reciprocals, i.e., 1/<u,v> but if u != v and they're orthonormal, we are dividing by 0. Hence, I went for 1/2^(u,v) which allows for the inner product to be 0, and as the inner product gets smaller, the overall value of its functions output gets bigger.

Anyway, thank you for checking this out. I enjoyed applying some of the theoretical linear algebra concepts I've learned recently. Hopefully, you appreciate this as much as I did.
