import networkx as nx
import random
import matplotlib.pyplot as plt

def create_ring_topology(n_nodes):
    """Create a ring topology with n_nodes."""
    G = nx.Graph()
    # Add nodes
    for i in range(n_nodes):
        G.add_node(i)
    # Connect each node to its next neighbor, closing the ring
    for i in range(n_nodes):
        G.add_edge(i, (i + 1) % n_nodes)
    return G

def create_grid_topology(n_nodes):
    """Create a grid topology with approximately n_nodes."""
    # Calculate grid dimensions
    grid_size = int(n_nodes ** 0.5)
    if grid_size ** 2 < n_nodes:
        grid_size += 1
    return nx.grid_2d_graph(grid_size, grid_size)

def create_complete_topology(n_nodes):
    """Create a complete graph with n_nodes."""
    return nx.complete_graph(n_nodes)

def create_barabasi_albert_topology(n_nodes):
    """Create a Barabási-Albert random graph with n_nodes."""
    # Each new node will be connected to 2 existing nodes
    m = 2
    return nx.barabasi_albert_graph(n_nodes, m)

def plot_topology(G, title):
    """Plot the network topology."""
    plt.figure(figsize=(8, 8))
    plt.title(title)
    nx.draw(G, with_labels=True, node_color='lightblue', 
            node_size=500, font_size=10, font_weight='bold')
    plt.show()

def main():
    n_nodes = 12  # You can change this number (must be >= 10)
    
    # Create and plot each topology
    topologies = {
        "Ring Topology": create_ring_topology(n_nodes),
        "Grid Topology": create_grid_topology(n_nodes),
        "Complete Topology": create_complete_topology(n_nodes),
        "Barabási-Albert Topology": create_barabasi_albert_topology(n_nodes)
    }
    
    # Print basic information about each topology
    for name, G in topologies.items():
        print(f"\n{name}:")
        print(f"Number of nodes: {G.number_of_nodes()}")
        print(f"Number of edges: {G.number_of_edges()}")
        print(f"Average degree: {sum(dict(G.degree()).values()) / G.number_of_nodes():.2f}")
        plot_topology(G, name)

if __name__ == "__main__":
    main()