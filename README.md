# icicle-async bench

results:

```
Groth16 Proof/Async     time:   [45.316 ms 45.508 ms 45.735 ms]
                        change: [-0.9675% -0.3977% +0.1200%] (p = 0.19 > 0.05)
                        No change in performance detected.
Groth16 Proof/Sync      time:   [46.799 ms 46.899 ms 47.016 ms]
                        change: [-0.7684% -0.3968% -0.0498%] (p = 0.06 > 0.05)
                        No change in performance detected.
```

It seems like no difference bw/ async and sync in rsa.

