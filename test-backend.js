const mongoose = require('mongoose');

// Test MongoDB connection
const testConnection = async () => {
  try {
    const connectionString = "mongodb://admin:admin123@localhost:27017/meandb?authSource=admin";
    
    console.log('🔄 Testing MongoDB connection...');
    await mongoose.connect(connectionString, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    
    console.log('✅ MongoDB connection successful!');
    
    // Test creating a document
    const testSchema = new mongoose.Schema({
      title: String,
      description: String,
      published: Boolean
    }, { timestamps: true });
    
    const TestModel = mongoose.model('Test', testSchema);
    
    const testDoc = new TestModel({
      title: 'Test Tutorial',
      description: 'This is a test tutorial',
      published: false
    });
    
    await testDoc.save();
    console.log('✅ Test document created successfully!');
    
    // Clean up
    await TestModel.deleteOne({ _id: testDoc._id });
    console.log('✅ Test document deleted successfully!');
    
    await mongoose.disconnect();
    console.log('✅ All tests passed! Backend is ready.');
    
  } catch (error) {
    console.error('❌ Connection failed:', error.message);
    process.exit(1);
  }
};

testConnection();
