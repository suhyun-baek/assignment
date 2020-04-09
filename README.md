## AWS VPC 및 WEB 서버 구성

#### 작성 언어 : Terraform v0.12.20

#### 구성 리소스
- VPC
  - VPC
  - Subnet
  - Internet Gateway
  - Route Table
  - Elastic IPs
  - NAT Gateway
  
- EC2 
  - Instances
  - Security Group
  - ALB
  
- S3

#### 프로젝트 구성 및 역할
  - bsh0817 : 네트워크 환경 구성및 Web 서버 구성
  - s3-state : 해당 계정의 tfstate 파일 관리 버킷

#### bsh0817 프로젝트 구성 설명 
  - VPC
    - 새로운 VPC에4개의 Subnet(DMZ, Web, Was, DB)구성
    - DMZ는 Route Table에 Internet Gateway연결
    - DMZ를 제외한 나머지 Subnet은 Route Table에 NAT Gateway를 연결
  - EC2
    - Instance는 Web Subnet에 구성 AMI는 Nginx가 셋팅된 것을 사용
    - ALB는 DMZ Subnet에 구성
    - ALB 보안 그룹은 80 포트는 모든 요청 허용
    - Instance 보안 그룹은 ALB 보안 그룹의 80 요청을 만을 허용

#### s3-state 프로젝트 구성 설명 
  - S3
    - tfstate 파일 관리버킷 구성
