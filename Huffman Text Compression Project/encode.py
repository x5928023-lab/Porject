import heapq
import pickle
from collections import Counter

class Node:
    def __init__(self, char=None, freq=0):
        self.char = char
        self.freq = freq
        self.left = None
        self.right = None
    
    def __lt__(self, other):
        return self.freq < other.freq

def build_tree(freq_map):
    heap = [Node(c, f) for c, f in freq_map.items()]
    heapq.heapify(heap)
    
    while len(heap) > 1:
        left = heapq.heappop(heap)
        right = heapq.heappop(heap)
        parent = Node(None, left.freq + right.freq)
        parent.left = left
        parent.right = right
        heapq.heappush(heap, parent)
    
    return heap[0]

def generate_codes(root):
    codes = {}
    
    if root.left is None and root.right is None:
        codes[root.char] = "0"
        return codes
    
    def dfs(node, path=""):
        if node is None:
            return
        if node.char is not None:
            codes[node.char] = path
            return
        dfs(node.left, path + "0")
        dfs(node.right, path + "1")
    
    dfs(root)
    return codes

def print_tree(node, indent="", prefix="Root: "):
    if node is None:
        return
    if node.char is not None:
        print(f"{indent}{prefix}Leaf(char='{node.char}', freq={node.freq})")
    else:
        print(f"{indent}{prefix}Internal(freq={node.freq})")
        if node.left:
            print_tree(node.left, indent + "  ", "L--- ")
        if node.right:
            print_tree(node.right, indent + "  ", "R--- ")

def main():
    with open("input.txt", "r", encoding="utf-8") as f:
        text = f.read()
    
    print("=" * 60)
    print("HUFFMAN ENCODING")
    print("=" * 60)
    print("\n=== INPUT TEXT ===")
    print(text)
    print(f"\nLength: {len(text)} characters")
    print()
    
    freq_map = Counter(text)
    print("=== FREQUENCY MAP ===")
    for char, freq in sorted(freq_map.items(), key=lambda x: x[1], reverse=True):
        display_char = repr(char) if char in ['\n', '\t', ' '] else f"'{char}'"
        print(f"{display_char}: {freq}")
    print()
    
    root = build_tree(freq_map)
    print("=== HUFFMAN TREE ===")
    print_tree(root)
    print()
    
    codes = generate_codes(root)
    print("=== HUFFMAN CODES ===")
    for char, code in sorted(codes.items(), key=lambda x: (len(x[1]), x[0])):
        display_char = repr(char) if char in ['\n', '\t', ' '] else f"'{char}'"
        print(f"{display_char}: {code}")
    print()
    
    encoded = "".join(codes[ch] for ch in text)
    with open("encoded.bin", "w") as f:
        f.write(encoded)
    
    print("=== COMPRESSED BITSTRING (first 200 bits) ===")
    print(encoded[:200] + "..." if len(encoded) > 200 else encoded)
    print()
    
    original_bits = len(text) * 8
    compressed_bits = len(encoded)
    compression_ratio = (1 - compressed_bits / original_bits) * 100
    
    print("=== COMPRESSION STATISTICS ===")
    print(f"Original size: {original_bits} bits ({len(text)} characters × 8 bits)")
    print(f"Compressed size: {compressed_bits} bits")
    print(f"Compression ratio: {compression_ratio:.2f}%")
    print(f"Space saved: {original_bits - compressed_bits} bits")
    print()
    
    with open("tree.pkl", "wb") as f:
        pickle.dump(root, f)
    
    print("=" * 60)
    print("Files generated:")
    print(" ✓ encoded.bin")
    print(" ✓ tree.pkl")
    print("=" * 60)

if __name__ == "__main__":
    main()
