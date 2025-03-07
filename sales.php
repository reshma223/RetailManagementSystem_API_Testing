<?php
// Database configuration
$servername = "localhost";
$username = "root";    // Set your DB username
$password = "";        // Set your DB password
$dbname = "RetailManagementSystem"; // Set your database name

// Create a connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "Database connection failed"]);
    exit();
}

// Set header for JSON response
header('Content-Type: application/json');

// Extract the action from the URL
$uri = explode('/', $_SERVER['REQUEST_URI']);
$action = end($uri);  // get, post, put, or delete

// Check if 'sale_id' is in the query parameters for GET by ID
if ($action === 'get' && isset($_GET['sale_id'])) {
    $sale_id = $_GET['sale_id'];
    $sql = "SELECT * FROM Sales WHERE sale_id = $sale_id";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $sale = $result->fetch_assoc();
        echo json_encode($sale);
    } else {
        http_response_code(404);
        echo json_encode(["message" => "Sale not found"]);
    }
    exit();
}

switch ($action) {
    case 'post':
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $data = json_decode(file_get_contents("php://input"), true);
            if (empty($data)) {
                http_response_code(400);
                echo json_encode(["error" => "No data provided"]);
                exit();
            }

            $customer_id = $data['customer_id'];
            $total_amount = $data['total_amount'];
            $payment_status = isset($data['payment_status']) ? $data['payment_status'] : 'Paid';
            $sale_date = isset($data['sale_date']) ? $data['sale_date'] : null;
            $salesperson_id = isset($data['salesperson_id']) ? $data['salesperson_id'] : null;

            $sql = "INSERT INTO Sales (customer_id, total_amount, payment_status, sale_date, salesperson_id) 
                    VALUES ('$customer_id', '$total_amount', '$payment_status', '$sale_date', '$salesperson_id')";
            if ($conn->query($sql) === TRUE) {
                http_response_code(201);
                echo json_encode(["message" => "Sale created successfully", "sale_id" => $conn->insert_id]);
            } else {
                http_response_code(500);
                echo json_encode(["error" => $conn->error]);
            }
        }
        break;

    case 'get':
        if ($_SERVER['REQUEST_METHOD'] === 'GET') {
            $sql = "SELECT * FROM Sales";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                $sales = [];
                while ($row = $result->fetch_assoc()) {
                    $sales[] = $row;
                }
                echo json_encode($sales);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "No sales found"]);
            }
        }
        break;

    case 'put':
        if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
            $data = json_decode(file_get_contents("php://input"), true);
            if (empty($data) || !isset($data['sale_id'])) {
                http_response_code(400);
                echo json_encode(["error" => "No data provided or sale_id missing"]);
                exit();
            }

            $sale_id = $data['sale_id'];
            $customer_id = $data['customer_id'];
            $total_amount = $data['total_amount'];
            $payment_status = $data['payment_status'];
            $sale_date = $data['sale_date'];
            $salesperson_id = $data['salesperson_id'];

            $sql = "UPDATE Sales SET customer_id='$customer_id', total_amount='$total_amount', 
                    payment_status='$payment_status', sale_date='$sale_date', salesperson_id='$salesperson_id' 
                    WHERE sale_id=$sale_id";
            if ($conn->query($sql) === TRUE) {
                if ($conn->affected_rows > 0) {
                    echo json_encode(["message" => "Sale updated successfully"]);
                } else {
                    http_response_code(404);
                    echo json_encode(["message" => "Sale not found"]);
                }
            } else {
                http_response_code(500);
                echo json_encode(["error" => $conn->error]);
            }
        }
        break;

    case 'delete':
        if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
            $data = json_decode(file_get_contents("php://input"), true);
            if (empty($data) || !isset($data['sale_id'])) {
                http_response_code(400);
                echo json_encode(["error" => "No data provided or sale_id missing"]);
                exit();
            }

            $sale_id = $data['sale_id'];
            $sql = "DELETE FROM Sales WHERE sale_id=$sale_id";
            if ($conn->query($sql) === TRUE) {
                if ($conn->affected_rows > 0) {
                    echo json_encode(["message" => "Sale deleted successfully"]);
                } else {
                    http_response_code(404);
                    echo json_encode(["message" => "Sale not found"]);
                }
            } else {
                http_response_code(500);
                echo json_encode(["error" => $conn->error]);
            }
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(["message" => "Unsupported operation"]);
        break;
}

// Close the database connection
$conn->close();
?>
