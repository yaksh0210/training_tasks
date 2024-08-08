#!/usr/bin/env python3

import json
import boto3

def get_inventory():
    ec2 = boto3.client('ec2', region_name='ap-south-1')
    response = ec2.describe_instances(Filters=[{'Name': 'tag:Role', 'Values': ['webserver']}, {'Name': 'tag:Name', 'Values': ['Yaksh']}])

    inventory = {
        'all': {
            'hosts': [],
            'vars': {}
        },
        '_meta': {
            'hostvars': {}
        }
    }

    ssh_key_file = '~/.ssh/My_key.pem'
    user = 'ubuntu'

    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            public_dns = instance.get('PublicDnsName', instance['InstanceId'])
            inventory['all']['hosts'].append(public_dns)
            inventory['_meta']['hostvars'][public_dns] = {
                'ansible_host': instance.get('PublicIpAddress', instance['InstanceId']),
                'ansible_user': user,
                'ansible_ssh_private_key_file': ssh_key_file
            }

    return inventory

if __name__ == '__main__':
    print(json.dumps(get_inventory(), indent=2))