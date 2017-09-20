---
title: "Markov Decision Processes"
date: 2013-7-04 19:12:12
tags:
  markov
  reinforcement-learning
---


To talk about Markov Decision Processes we venture into **Reinforcement Learning**, which is a kind of learning that is based on optimization using a **reward function**.  For example, let's say that we are training a robot to navigate a space without bumping into things.  Unlike with supervised learning where we have a clear set of labels that we want to derive, in this problem we have many potential states for the robot (moves it could make, places it could be), and so the idea of having concrete labels doesn't make much sense at all.  However, we can come up with a function that represents the goodness of some state (the reward function).  Using this function, we can give the robot points when he makes a move that we like, or take away points when he does something stupid (e.g., bumping into something!).  Our learning algorithm, then, will figure out the optimal actions to take for the robot over time to maximize this reward function.

**Reinforcement learning is based on the Markov Decision Process**

We will model our world as a set of states (S), actions (A), a reward function (R), and what are called transition probabilities (P), or the probability of transitioning *to* any particular combination of state and action *from* a particular state and action.  We start in some state, s-0, and take an action, a-0, based on the transition probabilities of that state, and then we arrive in a different state, s-0, and take a different action, etc.

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq110.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq110.png)

**Optimization starts with a reward function, R(s,a)**

Given that there is some reward (good or bad) associated with each of our decisions, it makes sense then, that the total reward of all of our decisions is a function of each action / state pair:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq111.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq111.png)

The extra parameter is intended to apply a "discount factor" to time, in the case that we need to discount rewards that are farther in the future.  Because we are stubborn and impatient and want things... now! :)  So, the goal of our learning algorithm is to maximize the expected value of the equation above.  Let's call the value that we get starting at some state, s, a function V(s).  It makes sense, then, that the expected reward starting at this state s is:

1. the reward that we get in the current state PLUS
2. the sum of the (discounted) rewards of all future states

We can write this as:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq112.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq112.png)

We could write an equation like this to model different possible combinations of states / actions, and we can define the **optimal value function** as the combination of states with the best V(s), meaning the highest possible reward:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq113.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq113.png)

This policy is optimal no matter what our starting state is.  Now, how do we find it?

**We optimize the value function with value iteration**

****This only works given that there is a finite number of states and actions, which seems reasonable for most learning problems.  The algorithm works as follows:

1. Initialize V(s) =0 for every finite state
2. Repeat until convergence {

For every state, update:      [![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq114.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq114.png)  
 }

The two algorithms, (and I'm not sure which is better), are generally the above, [value iteration](http://en.wikipedia.org/wiki/Markov_decision_process#Value_iteration), and there is also [policy iteration](http://en.wikipedia.org/wiki/Markov_decision_process#Policy_iteration).

For value iteration, we would want to solve for the optimal value function (above), and then plug this value into the equation below to find the optimal policy:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq115.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq115.png)

In the case above, we knew the transition probabilities in advance, however keep in mind that it's common to not know these probabilities, in which case you would need to update these transition probabilities before calculating the value function in each loop as follows:

[![eq1](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq116.png)](http://www.vbmis.com/learn/wp-content/uploads/2013/07/eq116.png)

and in the case that we get an undefined / NaN 0/0 it's best to have the probability equal to ![1/number-of-states](http://l.wordpress.com/latex.php?latex=1%2Fnumber-of-states&bg=FFFFFF&fg=470229&s=1 "1/number-of-states").

This isn't a completely satisfactory explanation of the algorithm, and that is because I haven't used Markov Decision Processes in my own research (it's more suited to robots and that sort of thing).  However, when I do I will update this post!


