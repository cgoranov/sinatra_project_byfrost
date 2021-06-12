
User.create(username: "cgoranov", password: "batman!")

User.create(username: "sanjana", password: "batman!")

User.create(username: "bwayne", password: "batman!")


Budget.find_or_create_by(name: "immunology", target: 500000, user_id: 1)

Budget.find_or_create_by(name: "oncology", target: 100000, user_id: 2)

Budget.find_or_create_by(name: "bat cave", target: 7000000, user_id: 3)


