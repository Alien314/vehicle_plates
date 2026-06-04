#define FRAME_MAX_PROGRESS				24
#define FRAME_MAX_IDLE					11
#define FRAME_MAX_IN					3

#define ACTION_HIDE_ON_USE				false
#define ACTION_SHORTCUT					""
#define ACTION_DISTANCE					15

#define TEXTURE_TEMPLATE_ICON_IDLE(icon)		(format["<img size='3' color='#ffffff' image='%1'/>",icon])
#define TEXTURE_TEMPLATE_ICON_PROGRESS(icon)		(format["<img size='3' color='#ffffff' image='%1'/>",icon])

#define TEXTURE_TEMPLATE_PROGRESS(frame)		(format["<img size='3' shadow='0' color='#ffffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress\progress_%1_ca.paa'/>",frame])	//frame 0-24
#define TEXTURE_TEMPLATE_IN(frame)			(format["<img size='3' shadow='0' color='#ffffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_%1_ca.paa'/>",frame])	//frame 0-3
#define TEXTURE_TEMPLATE_IDLE_PULSE(frame,color)	(format["<img size='3' shadow='0' color='%2' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_0_ca.paa'/>",frame,color])	//frame 0-3
#define TEXTURE_TEMPLATE_IDLE_ROTATION(frame)		(format["<img size='3' shadow='0' color='#ffffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\idle\idle_%1_ca.paa'/>",frame])	//frame 0-11

#define TEXTURES_PROGRESS				bis_fnc_holdAction_texturesProgress
#define TEXTURES_IDLE					bis_fnc_holdAction_texturesIdle
#define TEXTURES_IN					bis_fnc_holdAction_texturesIn
