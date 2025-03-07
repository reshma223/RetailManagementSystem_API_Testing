<?php
// Database configuration
$servername = "localhost";
$username = "root";    // Replace with your DB username
$password = "";        // Replace with your DB password
$dbname = "RetailManagementSystem"; // Replace with your database name

// Create a connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Set header for JSON response
header('Content-Type: application/json');

// Handle HTTP methods
$method = $_SERVER['REQUEST_METHOD'];

// Process CRUD operations based on the request method
switch ($method) {
    case 'POST':
        // Create a new product
        $data = json_decode(file_get_contents("php://input"), true);
        $name = $data['name'];
        $price = $data['price'];
        $stock_quantity = $data['stock_quantity'];
        $status = isset($data['status']) ? $data['status'] : 'Available';

        $sql = "INSERT INTO Products (name, price, stock_quantity, status) VALUES ('$name', '$price', '$stock_quantity', '$status')";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["message" => "Product created successfully", "product_id" => $conn->insert_id]);
        } else {
            echo json_encode(["error" => $conn->error]);
        }
        break;

    case 'GET':
        // Read product(s)
        if (isset($_GET['id'])) {
            // Fetch a single product by id
            $product_id = $_GET['id'];
            $sql = "SELECT * FROM Products WHERE product_id = $product_id";
        } else {
            // Fetch all products
            $sql = "SELECT * FROM Products";
        }
        $result = $conn->query($sql);
        $products = [];
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $products[] = $row;


            }
        }
        echo json_encode($products);
        break;

    case 'PUT':
        // Update an existing product
        $data = json_decode(file_get_contents("php://input"), true);
        $product_id = $data['product_id'];
        $name = $data['name'];
        $price = $data['price'];
        $stock_quantity = $data['stock_quantity'];
        $status = $data['status'];

        $sql = "UPDATE Products SET name='$name', price='$price', stock_quantity='$stock_quantity', status='$status' WHERE product_id=$product_id";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["message" => "Product updated successfully"]);
        } else {
            echo json_encode(["error" => $conn->error]);
        }
        break;

    case 'DELETE':
        // Delete a product
        $data = json_decode(file_get_contents("php://input"), true);
        $product_id = $data['product_id'];

        $sql = "DELETE FROM Products WHERE product_id=$product_id";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["message" => "Product deleted successfully"]);
        } else {
            echo json_encode(["error" => $conn->error]);
        }
        break;

    default:
        echo json_encode(["message" => "Unsupported HTTP method"]);
        break;
}

// Close the database connection
$conn->close();
?>
