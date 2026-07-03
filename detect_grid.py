import sys
from PIL import Image

def find_grid(image_path):
    img = Image.open(image_path)
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    width, height = img.size
    
    # Check rows and cols for transparency
    pixels = img.load()
    
    non_empty_cols = []
    for x in range(width):
        is_empty = True
        for y in range(height):
            if pixels[x, y][3] > 10:
                is_empty = False
                break
        if not is_empty:
            non_empty_cols.append(x)
            
    non_empty_rows = []
    for y in range(height):
        is_empty = True
        for x in range(width):
            if pixels[x, y][3] > 10:
                is_empty = False
                break
        if not is_empty:
            non_empty_rows.append(y)
            
    # Find contiguous non-empty regions (blocks)
    def find_blocks(indices):
        blocks = []
        if not indices: return blocks
        start = indices[0]
        for i in range(1, len(indices)):
            if indices[i] != indices[i-1] + 1:
                blocks.append((start, indices[i-1]))
                start = indices[i]
        blocks.append((start, indices[-1]))
        return blocks
        
    cols_blocks = find_blocks(non_empty_cols)
    rows_blocks = find_blocks(non_empty_rows)
    
    print(f"Detected {len(cols_blocks)} columns and {len(rows_blocks)} rows.")
    return len(cols_blocks), len(rows_blocks)

if __name__ == '__main__':
    find_grid('assets/animation/victory.png')
