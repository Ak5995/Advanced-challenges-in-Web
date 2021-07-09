# COM3014 - SnapFiles - CW2
Service functionalities and Database design


## How to build
1. Clone the repository
2. Ensure dependencies are installed
3. Open in IDE/Navigate to the folder through CLI
4. Run npm start / nodemon server.js 
5. Navigate to http://localhost:4001/user in the POSTMAN app. 


## Fields handled by the database 

| Title      | Type   | Note              |
|------------|--------|-------------------|
| _id        | String | autogen           |
|fileName    | String |from upload-delete | 
| fileId     | String |from upload-delete |
| userId     | String |from upload-delete |
|UploadedDate| String |from upload-delete |


### Example JSON file POST'ed upon requesting the files uploaded by users

```
{
    "UploadedDate": "2021-04-11T17:18:03.559Z"
    "fileName": "Test 1 development",
    "userId": "aj893756ncdhsjs",
    "fileId": "cnsdiaufhusu87623612",
    "__v": 0
}
```


## Routes

#### Add file uploaded by user

|POST       | Result                                                  | Note |
|-----------|---------------------------------------------------------|------|
| /user/add |stores files uploaded by the logged in user fileId,userId|Done  |

#### Delete listed file by logged in user 

|DELETE       | Result                                         | Note   |
|-------------|------------------------------------------------|--------|
|/user/:fileId| Delete the fileId of files uploaded by the user| Done   |

#### List of files uploaded by the user

|GET           | Result                                 | Note                   |
|--------------|----------------------------------------|------------------------|
|/user/:userId | Get files uploaded by a logged in user | Done                   |

#### Post delete request to url service 

|POST          | Result                                 | Note                  |
|--------------|----------------------------------------|-----------------------|
|/dud/delete   |Post FileId of the deleted file by user |   Done                |









