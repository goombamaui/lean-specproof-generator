from pantograph import Server

def main():
    server = Server(imports=['Mathlib'], project_path=".")
    print("Hello from lean-specproof!")


if __name__ == "__main__":
    main()
