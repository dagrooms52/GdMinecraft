# GdMinecraft

Generating Minecraft terrain in Godot using built-in nodes, no optimization.

![Terrain](https://github.com/user-attachments/assets/e4ad4481-c4f1-4cce-9828-83bfea0dfb85)

## What it does:
- Generates 16x16 chunks with default (Simplex) noise for surface height
- Generates more chunks as the player moves around
- Player can destroy blocks

## What it doesn't do:
- Block placement
- Any multithreading optimization
- Deallocate chunks out of range or sight
- Preload a chunk pool (this would help with new chunk loading lag)

## How to run it
- Open the project in Godot editor (last tested on Godot 4.3)
- Click play
