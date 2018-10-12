def run_transaction_and_retry_commit(client):
  with client.start_session() as s:
          s.start_transaction()
          collection_one.insert_one(doc1, session=s)
          collection_two.insert_one(doc2, session=s)
          while True:
              try:
                  s.commit_transaction()
                  break
              except (OperationFailure, ConnectionFailure) as exc:
                  if exc.has_error_label("UnknownTransactionCommitResult"):
                      print("Unknown commit result, retrying...")
                      continue
                  raise

while True:
  try:
      return run_transaction_and_retry_commit(client)
  except (OperationFailure, ConnectionFailure) as exc:
      if exc.has_error_label("TransientTransactionError"):
          print("Transient transaction error, retrying...")
          continue
      raise