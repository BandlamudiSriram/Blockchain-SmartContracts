pragma solidity >=0.7.0 <0.9.0;

contract Upload {
  
  struct FileAccess {
     address user; 
     bool hasAccess; //true or false
  }
  
  mapping(address=>string[]) private filesUploaded;
  mapping(address=>mapping(address=>bool)) private fileOwnership;
  mapping(address=>FileAccess[]) private accessList;
  mapping(address=>mapping(address=>bool)) private previousAccess;

  function addFile(address _user, string memory url) external {
      filesUploaded[_user].push(url);
  }

  function grantAccess(address user) external {//def
      fileOwnership[msg.sender][user]=true; 
      if(previousAccess[msg.sender][user]){
         for(uint i=0; i < accessList[msg.sender].length; i++){
             if(accessList[msg.sender][i].user == user){
                  accessList[msg.sender][i].hasAccess = true; 
             }
         }
      } else {
          accessList[msg.sender].push(FileAccess(user,true));  
          previousAccess[msg.sender][user]=true;  
      }
  }
  
  function revokeAccess(address user) external {
      fileOwnership[msg.sender][user]=false;
      for(uint i=0; i < accessList[msg.sender].length; i++){
          if(accessList[msg.sender][i].user == user){ 
              accessList[msg.sender][i].hasAccess = false;  
          }
      }
  }

  function displayFiles(address _user) external view returns(string[] memory){
      require(_user == msg.sender || fileOwnership[_user][msg.sender], "You don't have access");
      return filesUploaded[_user];
  }

  function getAccessList() external view returns(FileAccess[] memory){
      return accessList[msg.sender];
  }
}
