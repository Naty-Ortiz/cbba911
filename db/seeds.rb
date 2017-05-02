Role.create([{typename: 'ADMIN'},{typename: 'OFICIALDETURNO'}])



test_user = User.new
test_user.email = 'capitan@gmail.com'
test_user.username = 'capitan'
test_user.active = true
test_user.password = 'Admin1234.'
test_user.role = 0
test_user.save!
Person.create(first_name:'Capitan',last_name:'Capitan',identification_number:'5246352521',
              identification_type:'1',country:'BO',city:'C',address:'Por alla',
              user_id:1,phone_number:'70728566')
Employee.create(position:'1',profession:'Ofi',agent_id:'3234s',person_id:1)
test_user = User.new
test_user.email = 'oficialDeTurno@gmail.com'
test_user.username = 'oficialDeTurno'
test_user.active = true
test_user.password = 'Admin1234.'
test_user.role = 1
test_user.save!
Person.create(first_name:'oficialDeTurno',last_name:'oficial',
              identification_number:'234234',identification_type:'1',
              country:'BO',city:'C',address:'Por alla',
              user_id:2,phone_number:'70728566')
Employee.create(position:'3',profession:'Ofi',agent_id:'3234s',person_id:2)
