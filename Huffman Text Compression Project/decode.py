import pickle

class Node:
    def __init__(self, char=None, freq=0):
        self.char = char
        self.freq = freq
        self.left = None
        self.right = None

def decode(encoded, root):
    result = []
    node = root
    
    for bit in encoded:
        node = node.left if bit == "0" else node.right
        if node.char is not None:
            result.append(node.char)
            node = root
    
    return "".join(result)

def main():
    print("=" * 60)
    print("HUFFMAN DECODING")
    print("=" * 60)
    
    print("\n=== Loading compressed file ===")
    with open("encoded.bin", "r") as f:
        encoded = f.read()
    
    print(f"Compressed size: {len(encoded)} bits")
    print("\n=== ENCODED BITSTRING (first 200 bits) ===")
    print(encoded[:200] + "..." if len(encoded) > 200 else encoded)
    print()
    
    print("=== Loading Huffman tree ===")
    with open("tree.pkl", "rb") as f:
        root = pickle.load(f)
    print("✓ Tree loaded successfully")
    print()
    
    print("=== Decoding... ===")
    decoded = decode(encoded, root)
    print(f"✓ Decoded {len(decoded)} characters")
    print()
    
    with open("reconstructed.txt", "w", encoding="utf-8") as f:
        f.write(decoded)
    
    print("=== RECONSTRUCTED TEXT ===")
    print(decoded)
    print()
    
    print("=== VERIFICATION ===")
    try:
        with open("input.txt", "r", encoding="utf-8") as f:
            original = f.read()
        
        if decoded == original:
            print("✓ SUCCESS: Reconstructed text matches original!")
            print(f"  - Both have {len(decoded)} characters")
        else:
            print("✗ WARNING: Reconstructed text does NOT match original!")
            print(f"  - Original: {len(original)} chars, Decoded: {len(decoded)} chars")
    except FileNotFoundError:
        print("⚠ input.txt not found - cannot verify")
    
    print()
    print("=" * 60)
    print("File generated:")
    print(" ✓ reconstructed.txt")
    print("=" * 60)

if __name__ == "__main__":
    main()
