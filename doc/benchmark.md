







```
docker swarm init --advertise-addr=172.20.2.115
docker swarm join-token worker 

```

```
docker swarm join --token SWMTKN-1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyyyyyyyyyyy 172.20.2.115:2377
```

```
docker node update --label-add group=api t07 
docker node update --label-add group=jobs t08 
```




