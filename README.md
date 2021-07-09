# SnapFile

 Snapfile is a temporary file sharing platform, that allow users to share larger files with one another. The platform allows the users to effectively control distribution of files with strong sharing restrictions for the usage of small business owners, freelancers and musicians to large scale businesses.
 
 ### Key Words: Kubernetes & Google Kubernetes Engine, Docker, Firebase, AWS S3, Mongo DB, Node JS
 
 ## Functional Requirements
The main functionalities of the flatform are as follows:

1. Anonymous users and registered users can upload files.
2. Handle various file types.
3. Handle files larger than 25mb
4. Can set access limits on uploaded file
   - Each request for the file decrements entry limit
   - Users are denied access when access limit is reached
• Can set time limit on uploaded file
5. Users are denied access when entry limit is reached
   - Users can pre-emptively delete uploaded files
   - All following requests to the deleted file are denied
   
## Non-functional Requirements
The non-functional requirements of the platform based on the requirements of the coursework:
1. High horizontal scalability
2. Fast to implement new features
