## code repository for scalable spectral clustering with group fairness constraints

### code structure
```
-- src
 -- alg1.m: SC 
 -- alg2.m: FairSC
 -- alg3.m: s-FairSC
 -- Afun.m: spmv function to eig in alg3.m
 -- Afun2.m: spmv function to eig in alg1.m and alg2.m
-- test
 -- m-SBM: experiment on the Modified Stochastic Block Model 
 -- lastfm: experiment on Last.fm dataset
 -- friendship: experiment on FacebookNet dataset
 -- ranLap: experiment on random Laplacian
 ```

alg1.m, alg2.m, and part of m-SBM are credited to https://github.com/matthklein/fair_spectral_clustering

Real dataset: [Last.fm](http://snap.stanford.edu/data/feather-lastfm-social.html) | [FacebookNet](http://www.sociopatterns.org/datasets/high-school-contact-and-friendship-networks/)

Paper is accepted at the 26th International Conference on Artificial Intelligence and Statistics (AISTATS 2023).
Proceedings available at https://proceedings.mlr.press/v206/wang23h.html
