#!/bin/bash

echo "🚀 Starting Tutorial Manager Application..."

# Start with Docker Compose
echo "📦 Starting services with Docker Compose..."
docker-compose up -d

echo "✅ Application started successfully!"
echo ""
echo "🌐 Access your application:"
echo "   Frontend: http://localhost"
echo "   Backend API: http://localhost:3000"
echo "   MongoDB: localhost:27017"
echo ""
echo "📊 To view logs:"
echo "   docker-compose logs -f"
echo ""
echo "🛑 To stop:"
echo "   docker-compose down"
