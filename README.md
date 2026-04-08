# PrestaShop Automated Test Suite

This repository contains the functional Robot Framework test suite for PrestaShop 9 (Hummingbird theme).

## Docker setup (required)

1. Start Docker Desktop.
2. From the project root, start the stack:

```powershell
docker compose up -d
```

3. Wait until both containers are running:

```powershell
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
```

Expected container names in this project:
- `ps-db` (MySQL)
- `ps-app` (PrestaShop)

4. Open PrestaShop at:
- `http://localhost:8080/`

## Python test environment setup

Install test dependencies from the repository root:

```powershell
pip install -r requirements.txt
```

## Required test data reset (run before tests)

Run the following PowerShell here-string command before executing the test suite. This enforces known stock states required by the tests:

```powershell
@"
UPDATE ps_stock_available SET quantity = 0, out_of_stock = 0 WHERE id_product = 8;
UPDATE ps_product SET available_for_order = 0 WHERE id_product = 8;
UPDATE ps_stock_available SET quantity = 10, out_of_stock = 0 WHERE id_product = 2;
"@ | docker exec -i ps-db mysql -u root -padmin prestashop
```

What this does:
- Product 2 is set to in stock (quantity 10) for add-to-cart and cart-flow tests.
- Product 8 is forced out of stock and unavailable for order for out-of-stock validation tests.

## Running tests

Run all tests from the repository root:

```powershell
python -m robot tests/
```
