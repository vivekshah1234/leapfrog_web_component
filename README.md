<h1 align="center">
   leapfrog_web_component
</h1>

<h2 align="center"> Flutter package to create slidable drawer specially for web.</h2>


<h1> Web </h1>

![web_drawer_gif](https://github.com/user-attachments/assets/5139ab2e-a1ea-4a5c-b881-c256c4bf3377)


## Features

- This widget will provice you to user drawer in flutter web

## Getting Start

- To use this dependency, add it to your pubspec.yaml file:



## Basic Example
```dart
class WrapWithDrawer extends StatelessWidget {
  const WrapWithDrawer({super.key, required this.child, required this.pageTitle});
  final Widget child;
  final String pageTitle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDrawer(
        menuItems: menuItems,
        onMenuTap: (route) => context.push(route),
        profileImageUrl: 'assets/user_place_holder.png',
        onLogOutClick: () {},
        isShowUserProfile: true,
        profileBackground: Colors.black,
        drawerIconSize: 26,
        userFirstName: "John",
        userLastName: "Doe",
        titleName: pageTitle,
        isSearchShow: true,
        headerColor: Colors.blue,
        drawerColor: Colors.black,
        version: "1.0.0",
        titleStyle: const TextStyle(color: Colors.white, fontSize: 20),
        userNameStyle: const TextStyle(color: Colors.white, fontSize: 16),
        drawerIconColor: Colors.red,
        userEmail: "jH9o7@example.com",
        drawerTextSelectedColor: Colors.white,
        prefix: SizedBox(),
        isShowClearIcon: false,
        isShowUserName: true,
        //headerWidget: SizedBox.shrink(),
        drawerHeader: Column(
          children: [
            CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/user_place_holder.png')),
            SizedBox(height: 10),
            Text("John Doe", style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 10),
            Text("jH9o7@example.com", style: TextStyle(color: Colors.white, fontSize: 12)),
            SizedBox(height: 10),
          ],
        ),
        child: child,
      ),
    );
  }
}
```