db.data.aggregate([
  {
    "$unwind": "$turnstile"
  },
  {
    "$group": {
      "_id": 0,
      "sum": {
        "$sum": {         
			$convert: {
			  input: "$turnstile.count",
			  to: "int",
			  onError: 0,
			  onNull: 0
			}		  
        }
      }
    }
  }
])