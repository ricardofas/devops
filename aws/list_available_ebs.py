import boto3
ec2 = boto3.resource('ec2',region_name='eu-west-1')
total_cost=0
for vol in ec2.volumes.all():
    if vol.state=="available":
        ebscost = vol.size * 0.11
        print ("The volume {id} is available, has {size}GB, type {volume_type} and costs {cost}USD / month".format(id=vol.id,size=vol.size,volume_type=vol.volume_type,cost=ebscost))
        total_cost=total_cost+ebscost
print "Total cost is: {:.5f} USD / monthly".format(total_cost) 
