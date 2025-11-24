# icicle-async bench

results:

## RSA circuit:

```bash
RSA Proof/Async     time:   [45.316 ms 45.508 ms 45.735 ms]
                        change: [-0.9675% -0.3977% +0.1200%] (p = 0.19 > 0.05)
                        No change in performance detected.
RSA Proof/Sync      time:   [46.799 ms 46.899 ms 47.016 ms]
                        change: [-0.7684% -0.3968% -0.0498%] (p = 0.06 > 0.05)
                        No change in performance detected.
```

## 400k circuit:

```bash
400k Proof/Async     time:   [94.014 ms 94.352 ms 94.686 ms]
                        change: [+106.31% +107.17% +108.03%] (p = 0.00 < 0.05)
                        Performance has regressed.
400k Proof/Sync      time:   [97.907 ms 98.161 ms 98.417 ms]
                        change: [+108.81% +109.51% +110.27%] (p = 0.00 < 0.05)
                        Performance has regressed.
```


## 1600k circuit:

```bash
1600k circuit Proof/Async
                        time:   [313.79 ms 314.26 ms 314.69 ms]
1600k circuit Proof/Sync
                        time:   [328.01 ms 328.95 ms 329.99 ms]
```

