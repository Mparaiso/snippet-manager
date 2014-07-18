class Acl
    constructor:(@userPermission,@RolePermission)->

    check:(permission,userId,groupId)->
        @userPermission(permission,userId)
        .catch => @groupPermission(permission,groupId)
        .catch -> throw "user with id #{userId} and group id #{groupId} not allowed to perform #{permission}" if not (userPermission or groupPermission)
        .then -> true
   
    userPermission:(permission,userId)->
        @userPermission.count({where:{user_id:userId,permission_name:permission,permission_type:1}})
        .then (count)-> throw "not found" if count is 0

    groupPermission:(permission,userId)->
        @groupPermission.count({where:{user_id:userId,permission_name:permission,permission_type:1}})
        .then (count)-> throw "not found" if count is 0
           
module.exports = Acl 
