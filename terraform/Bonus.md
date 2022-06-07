The terraform scripts which i have added, created infra in us-east-1 region. Can be modified to deploy in another region.

### Multiple regions hosting
For traffic across different regions, the recommended approach is to have : 
a. transit gateway in each region
b. 2 aws direct connect gateways
c. one megaport cloud router (MCR)
d. A transit virtual interface between each MCR and AWS Direct Connect gateway.
e. An association between the AWS Transit Gateway and its corresponding AWS Direct Connect gateway.
