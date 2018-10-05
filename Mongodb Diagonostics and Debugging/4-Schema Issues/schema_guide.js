// Schema for One-to-Few, use array of embed documents
db.person.findOne()
{
  name: 'Kate Monster',
  ssn: '123-456-7890',
  addresses : [
     { street: '123 Sesame St', city: 'Anytown', cc: 'USA' },
     { street: '123 Avenue Q', city: 'New York', cc: 'USA' }
  ]
}

// One-to-Many or 'n' side has to stand alone, use array of references
db.parts.findOne()
{
    _id : ObjectID('AAAA'),
    partno : '123-aff-456',
    name : '#4 grommet',
    qty: 94,
    cost: 0.94,
    price: 3.99
}
db.products.findOne()
{
    name : 'left-handed smoke shifter',
    manufacturer : 'Acme Corp',
    catalog_number: 1234,
    parts : [     // array of references to Part documents
        ObjectID('AAAA'),    // reference to the #4 grommet above
        ObjectID('F17C'),    // reference to a different Part
        ObjectID('D2AA'),
    ]
}

// Fetch the Product document identified by this catalog number
product = db.products.findOne({catalog_number: 1234});
// Fetch all the Parts that are linked to this Product
product_parts = db.parts.find({_id: { $in : product.parts } } ).toArray() ;

// One-to-Squillions, use parent reference from N to one
db.hosts.findOne()
{
    _id : ObjectID('AAAB'),
    name : 'goofy.example.com',
    ipaddr : '127.66.66.66'
}

db.logmsg.findOne()
{
    time : ISODate("2014-03-28T09:42:41.382Z"),
    message : 'cpu is on fire!',
    host: ObjectID('AAAB')       // Reference to the Host document
}

// find the parent ‘host’ document
host = db.hosts.findOne({ipaddr : '127.66.66.66'});  
// find the most recent 5000 log message documents linked to that host
last_5k_msg = db.logmsg.find({host: host._id}).sort({time : -1}).limit(5000).toArray()

// Two-Way reference
db.person.findOne()
{
    _id: ObjectID("AAF1"),
    name: "Kate Monster",
    tasks [     // array of references to Task documents
        ObjectID("ADF9"), 
        ObjectID("AE02"),
        ObjectID("AE73") 
        // etc
    ]
}

db.tasks.findOne()
{
    _id: ObjectID("ADF9"), 
    description: "Write lesson plan",
    due_date:  ISODate("2014-04-01"),
    owner: ObjectID("AAF1")     // Reference to Person document
}

// Denormalizing from many to one, consider the write/read ratio when denormalizing, the frequency of read >>> the frequency of write
db.products.findOne()
{
    name : 'left-handed smoke shifter',
    manufacturer : 'Acme Corp',
    catalog_number: 1234,
    parts : [     // array of references to Part documents
        ObjectID('AAAA'),    // reference to the #4 grommet above
        ObjectID('F17C'),    // reference to a different Part
        ObjectID('D2AA'),
    ]
}

db.products.findOne()
{
    name : 'left-handed smoke shifter',
    manufacturer : 'Acme Corp',
    catalog_number: 1234,
    parts : [
        { id : ObjectID('AAAA'), name : '#4 grommet' },         // Part name is denormalized
        { id: ObjectID('F17C'), name : 'fan blade assembly' },
        { id: ObjectID('D2AA'), name : 'power switch' },
    ]
}

// Fetch the product document
product = db.products.findOne({catalog_number: 1234});  
// Create an array of ObjectID()s containing *just* the part numbers
part_ids = product.parts.map( function(doc) { return doc.id } );
// Fetch all the Parts that are linked to this Product
product_parts = db.parts.find({_id: { $in : part_ids } } ).toArray() ;

// Denormalizing from one to many
db.parts.findOne()
{
    _id : ObjectID('AAAA'),
    partno : '123-aff-456',
    name : '#4 grommet',
    product_name : 'left-handed smoke shifter',   // Denormalized from the ‘Product’ document
    product_catalog_number: 1234,                    
    qty: 94,
    cost: 0.94,
    price: 3.99
}

// Denormalizing with "one-to-squillion" relationship
db.logmsg.findOne()
{
    time : ISODate("2014-03-28T09:42:41.382Z"),
    message : 'cpu is on fire!',
    ipaddr : '127.66.66.66',
    hostname : 'goofy.example.com',
}

// Get log message from monitoring system
logmsg = get_log_msg();
log_message_here = logmsg.msg;
log_ip = logmsg.ipaddr;
// Get current timestamp
now = new Date()
// Find the _id for the host I’m updating
host_doc = db.hosts.findOne({ipaddr : log_ip },{_id:1});  // Don’t return the whole document
host_id = host_doc._id;
// Insert the log message, the parent reference, and the denormalized data into the ‘many’ side
db.logmsg.save({time : now, message : log_message_here, ipaddr : log_ip, host : host_id ) });
// Push the denormalized log message onto the ‘one’ side
db.hosts.update( {_id: host_id }, 
        {$push : {logmsgs : { $each:  [ { time : now, message : log_message_here } ],
                           $sort:  { time : 1 },  // Only keep the latest ones 
                           $slice: -1000 }        // Only keep the latest 1000, arrays should not grow without bound.
         }} );












































