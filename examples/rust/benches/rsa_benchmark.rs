use criterion::{criterion_group, criterion_main, Criterion};
use icicle_snark::{groth16_prove, groth16_prove_not_async, CacheManager};
use std::path::Path;

fn groth16_benchmark(c: &mut Criterion) {
    let mut cache_manager = CacheManager::default();
    let base_path = "../../benchmark/rsa/";
    let witness = format!("{}witness.wtns", base_path);
    let zkey = format!("{}circuit_final.zkey", base_path);
    let proof = format!("{}proof.json", base_path);
    let public = format!("{}public.json", base_path);
    let device = "CUDA";

    // Ensure files exist
    if !Path::new(&witness).exists() || !Path::new(&zkey).exists() {
        panic!("Benchmark files not found at {}", base_path);
    }

    // Pre-compute cache to avoid benchmarking setup time
    let cache_key = format!("{}_{}", zkey, device);
    if !cache_manager.contains(&cache_key) {
        // We need to initialize backend first
        // groth16_prove handles this, but we want to do it before benchmark loop if possible.
        // However, groth16_prove calls try_load_and_set_backend_device.
        // Let's run it once to warm up and populate cache.
        groth16_prove(&witness, &zkey, &proof, &public, device, &mut cache_manager).unwrap();
    }

    let mut group = c.benchmark_group("Groth16 Proof");
    group.sample_size(10); // Reduce sample size as it takes time

    group.bench_function("Async", |b| {
        b.iter(|| {
            groth16_prove(&witness, &zkey, &proof, &public, device, &mut cache_manager).unwrap();
        })
    });

    group.bench_function("Sync", |b| {
        b.iter(|| {
            groth16_prove_not_async(&witness, &zkey, &proof, &public, device, &mut cache_manager)
                .unwrap();
        })
    });

    group.finish();
}

criterion_group!(benches, groth16_benchmark);
criterion_main!(benches);
