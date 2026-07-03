import sys
from PIL import Image

def make_webp(input_path, output_path, cols=5, rows=5):
    img = Image.open(input_path).convert("RGBA")
    
    width, height = img.size
    frame_w = width // cols
    frame_h = height // rows
    
    frames = []
    
    for r in range(rows):
        for c in range(cols):
            box = (c * frame_w, r * frame_h, (c + 1) * frame_w, (r + 1) * frame_h)
            frame = img.crop(box)
            frames.append(frame)

    frames[0].save(
        output_path,
        save_all=True,
        append_images=frames[1:],
        duration=40,
        loop=0,
        method=4, # WebP compression method
        lossless=True
    )
    print(f"Saved {output_path} with {len(frames)} frames as WebP.")

if __name__ == '__main__':
    make_webp('assets/animation/victory.png', 'assets/animation/victory.webp', 5, 5)
    make_webp('assets/animation/shy.png', 'assets/animation/shy.webp', 5, 5)
