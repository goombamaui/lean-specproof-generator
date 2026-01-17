## Setup

### 1. Python Dependencies
Install [uv](https://docs.astral.sh/uv/) if you don't have it. Then, 
install dependencies using:
```bash
# Install Python dependencies
uv sync
```

This will create a virtual environment and install all required packages.

### 2. Lean Setup
```bash
lake exe cache get
lake build
```

**Important:** Running `lake exe cache get` downloads precompiled Mathlib files (~1 minute) instead of building from source (several hours).

### 3. Set API Key

Create a `.env` file in the project root:
```bash
ANTHROPIC_API_KEY=your_api_key_here
```

## Generating Proofs
Read `test.ipynb` to understand how to generate proofs.