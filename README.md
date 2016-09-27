TWG4
=======
![TWG4 Logo](http://drive.google.com/uc?export=view&id=0B3GgZp93pdYZdnJpZmNYMEdJb0U)

**TWG4 is a photo gallery application.** It allows you to upload your photos, group them into albums, and easily share only with selected group of people, like family and friends.


Demo
-------
The demo version is available here:

**https://twg4.herokuapp.com**

To log in, use one of the fallowing credentials:

```
username: sadmin
password: sadmin1024
permissions: Super admin - It is the most privileged user, it has permission to do everything.
                           It is still restricted by the demo version restrictions (described below).
```
```
username: admin
password: admin512
permissions: Admin - Can do everything that normal user can + Can modify all albums, photos and comments, except those
                     owned/authored by other admins and super admins + Can access users list and user's profiles +
                     Can create new users and modify existing users, except admins and super admins.
```
```
username: mod
password: mod16
permissions: Moderator - Can do everything that normal user can + Can modify all comments, except those authored by admins
                         and super admins.
```
```
username: user
password: user8
permissions: Normal user - Can access all albums and photos. Can create new albums and modify albums that it owns.
                           Can comment photos and modify comments that it authored. Can access its own user profile.
```

Note that in order to provide lasting usability, the demo version has some additional restrictions, that are not present in normal version of the app. In particular **the demo version do not allow** you to:

  * Upload new photos and delete already uploaded photos
  * Add or remove photos from album that is owned by "TeWu" user
  * Edit or delete albums and comments that are owned/authored by "TeWu" user
  * Edit or delete "TeWu" user and users with credentials given above
