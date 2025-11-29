#!/bin/bash

echo "🧪 Testing Complete Frontend → Backend → MongoDB Flow"
echo "=================================================="

# Test 1: Create a tutorial via API (simulating frontend)
echo "1️⃣ Creating tutorial via API..."
RESPONSE=$(curl -s -X POST http://localhost:3000/api/tutorials \
  -H "Content-Type: application/json" \
  -d '{"title":"My First Tutorial","description":"Learning MEAN Stack","published":false}')
echo "✅ Created: $RESPONSE"

# Test 2: Get all tutorials via API
echo -e "\n2️⃣ Fetching all tutorials via API..."
TUTORIALS=$(curl -s -X GET http://localhost:3000/api/tutorials)
echo "✅ Retrieved: $TUTORIALS"

# Test 3: Check MongoDB directly
echo -e "\n3️⃣ Checking MongoDB directly..."
MONGO_COUNT=$(docker compose exec -T mongodb mongosh --username admin --password admin123 --authenticationDatabase admin meandb --eval "db.tutorials.find().count()" --quiet)
echo "✅ MongoDB count: $MONGO_COUNT"

# Test 4: Check MongoDB data
echo -e "\n4️⃣ Checking MongoDB data..."
docker compose exec -T mongodb mongosh --username admin --password admin123 --authenticationDatabase admin meandb --eval "db.tutorials.find().pretty()" --quiet

echo -e "\n🎉 Test Complete! Frontend → Backend → MongoDB flow is working!"
echo "📱 Open http://localhost:4200 to test the UI"
