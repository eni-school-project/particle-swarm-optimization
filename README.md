# Particle Swarm Optimization

This is a school project that is supposed to visualize the algorithm of PSO.

Given:

- a number of particles $N$ in a swarm
- an objective to reach, $P_i$ for each particle at time $t$
- a position, $X_i$ for each particle at time $t$ with

```math
X_i = \begin{pmatrix} x_i \\ y_i \end{pmatrix} \text{ and possibly } z_i
```

- a velocity, $V_i$ for each particle at time $t$
- a global objective, $P_g$ relative to the neighbourhood where

```math
P_g = \text{the position of the particle that is closest to the objective } P_i
```

> [!IMPORTANT]
>
> The goal is for each particle $i$ in the swarm to calculate its next velocity $V^{t+1}_i$
> based on 4 major parameters:
>
> - its current velocity $V^t_i$
> - its objective $P^t_i$
> - its position $X^t_i$
> - and the global objective $P^t_g$
>
> With additional parameters like:
>
> - $r_1$ and $r_2$, random numbers $\in [0, 1]$
> - $\omega$, the inertia
