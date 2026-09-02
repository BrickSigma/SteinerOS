
build/boot/bios/stage2/SecondStageBootloader.elf:     file format elf32-i386


Disassembly of section .text:

00007e00 <_start>:
    7e00:	88 16                	mov    %dl,(%esi)
    7e02:	5f                   	pop    %edi
    7e03:	7e b4                	jle    7db9 <BOOTLOADER_SIZE+0x71b9>
    7e05:	03 b7 00 cd 10 80    	add    -0x7fef3300(%edi),%esi
    7e0b:	cd 20                	int    $0x20
    7e0d:	b4 01                	mov    $0x1,%ah
    7e0f:	cd 10                	int    $0x10
    7e11:	e8 e2 01 83 f8       	call   f8837ff8 <_cursor+0xf882f950>
    7e16:	01 74 0e           	add    %esi,-0x18(%esi,%ecx,1)

00007e19 <_a20_error>:
    7e19:	e8 b6 01 be b0       	call   b0be7fd4 <_cursor+0xb0bdf92c>
    7e1e:	7f b9                	jg     7dd9 <BOOTLOADER_SIZE+0x71d9>
    7e20:	20 00                	and    %al,(%eax)
    7e22:	e8 9a 00 eb 34       	call   34eb7ec1 <_cursor+0x34eaf819>

00007e27 <_a20_enabled>:
    7e27:	be 9d 7f b9 13       	mov    $0x13b97f9d,%esi
    7e2c:	00 e8                	add    %ch,%al
    7e2e:	8f 00                	pop    (%eax)
    7e30:	66 b8 74 81          	mov    $0x8174,%ax
    7e34:	00 00                	add    %al,(%eax)
    7e36:	66 bb 6c 81          	mov    $0x816c,%bx
    7e3a:	00 00                	add    %al,(%eax)
    7e3c:	66 b9 70 81          	mov    $0x8170,%cx
    7e40:	00 00                	add    %al,(%eax)
    7e42:	e8 ba 00 72 0b       	call   b727f01 <_cursor+0xb71f859>
    7e47:	be 89 7e b9 36       	mov    $0x36b97e89,%esi
    7e4c:	00 e8                	add    %ch,%al
    7e4e:	6f                   	outsl  %ds:(%esi),(%dx)
    7e4f:	00 eb                	add    %ch,%bl
    7e51:	09         	or     %edi,0x29b97e60(%esi)

00007e52 <_call_failed>:
    7e52:	be 60 7e b9 29       	mov    $0x29b97e60,%esi
    7e57:	00 e8                	add    %ch,%al
    7e59:	64 00              	fs add %bh,%dl

00007e5b <_hang>:
    7e5b:	fa                   	cli
    7e5c:	f4                   	hlt
    7e5d:	eb fc                	jmp    7e5b <_hang>

00007e5f <DRIVE_NUMBER>:
	...

00007e60 <PM_CB_FAILED>:
    7e60:	43                   	inc    %ebx
    7e61:	6f                   	outsl  %ds:(%esi),(%dx)
    7e62:	75 6c                	jne    7ed0 <gdt_offset+0x3>
    7e64:	64 20 6e 6f          	and    %ch,%fs:0x6f(%esi)
    7e68:	74 20                	je     7e8a <PM_SUCCESS+0x1>
    7e6a:	63 61 6c             	arpl   %esp,0x6c(%ecx)
    7e6d:	6c                   	insb   (%dx),%es:(%edi)
    7e6e:	20 70 72             	and    %dh,0x72(%eax)
    7e71:	6f                   	outsl  %ds:(%esi),(%dx)
    7e72:	74 65                	je     7ed9 <kernel_code_segment>
    7e74:	63 74 65 64          	arpl   %esi,0x64(%ebp,%eiz,2)
    7e78:	20 6d 6f             	and    %ch,0x6f(%ebp)
    7e7b:	64 65 20 66 75       	fs and %ah,%gs:0x75(%esi)
    7e80:	6e                   	outsb  %ds:(%esi),(%dx)
    7e81:	63 74 69 6f          	arpl   %esi,0x6f(%ecx,%ebp,2)
    7e85:	6e                   	outsb  %ds:(%esi),(%dx)
    7e86:	21 0d 0a       	and    %ecx,0xa0a0d0a

00007e89 <PM_SUCCESS>:
    7e89:	0d 0a 0a 43 20       	or     $0x20430a0a,%eax
    7e8e:	66 75 6e             	data16 jne 7eff <pm_function_cb>
    7e91:	63 74 69 6f          	arpl   %esi,0x6f(%ecx,%ebp,2)
    7e95:	6e                   	outsb  %ds:(%esi),(%dx)
    7e96:	20 63 61             	and    %ah,0x61(%ebx)
    7e99:	6c                   	insb   (%dx),%es:(%edi)
    7e9a:	6c                   	insb   (%dx),%es:(%edi)
    7e9b:	20 77 6f             	and    %dh,0x6f(%edi)
    7e9e:	72 6b                	jb     7f0b <pm_function_cb+0xc>
    7ea0:	65 64 21 20          	gs and %esp,%fs:(%eax)
    7ea4:	42                   	inc    %edx
    7ea5:	61                   	popa
    7ea6:	63 6b 20             	arpl   %ebp,0x20(%ebx)
    7ea9:	69 6e 20 31 36 2d 62 	imul   $0x622d3631,0x20(%esi),%ebp
    7eb0:	69 74 20 72 65 61 6c 	imul   $0x206c6165,0x72(%eax,%eiz,1),%esi
    7eb7:	20 
    7eb8:	6d                   	insl   (%dx),%es:(%edi)
    7eb9:	6f                   	outsl  %ds:(%esi),(%dx)
    7eba:	64 65 21 0d 0a   	fs and %ecx,%gs:0xeb4600a
    7ec1:	 

00007ebf <print>:
    7ebf:	60                   	pusha

00007ec0 <_print_loop>:
    7ec0:	b4 0e                	mov    $0xe,%ah
    7ec2:	8a 04 46             	mov    (%esi,%eax,2),%al
    7ec5:	cd 10                	int    $0x10
    7ec7:	e2 f7                	loop   7ec0 <_print_loop>
    7ec9:	61                   	popa
    7eca:	c3                   	ret

00007ecb <gdt_size>:
    7ecb:	27                   	daa
	...

00007ecd <gdt_offset>:
    7ecd:	d1 7e 00             	sarl   $1,0x0(%esi)
	...

00007ed1 <gdt>:
	...

00007ed9 <kernel_code_segment>:
    7ed9:	ff                   	(bad)
    7eda:	ff 00                	incl   (%eax)
    7edc:	00 00                	add    %al,(%eax)
    7ede:	9a cf 00     	lcall  $0x0,$0xffff00cf

00007ee1 <kernel_data_segment>:
    7ee1:	ff                   	(bad)
    7ee2:	ff 00                	incl   (%eax)
    7ee4:	00 00                	add    %al,(%eax)
    7ee6:	92                   	xchg   %eax,%edx
    7ee7:	cf                   	iret
	...

00007ee9 <real_mode_code_segment>:
    7ee9:	ff                   	(bad)
    7eea:	ff 00                	incl   (%eax)
    7eec:	00 00                	add    %al,(%eax)
    7eee:	9a 0f 00     	lcall  $0x0,$0xffff000f

00007ef1 <real_mode_data_segment>:
    7ef1:	ff                   	(bad)
    7ef2:	ff 00                	incl   (%eax)
    7ef4:	00 00                	add    %al,(%eax)
    7ef6:	92                   	xchg   %eax,%edx
    7ef7:	0f 00                	(bad)

00007ef9 <gdt_end>:
    7ef9:	ff 03                	incl   (%ebx)

00007efb <idt_real_offset>:
    7efb:	00 00                	add    %al,(%eax)
	...

00007eff <pm_function_cb>:
    7eff:	66 60                	pushaw
    7f01:	be 81 7f b9 1c       	mov    $0x1cb97f81,%esi
    7f06:	00 e8                	add    %ch,%al
    7f08:	b5 ff                	mov    $0xff,%ch
    7f0a:	fa                   	cli
    7f0b:	e8 cd 00 89 26       	call   26897fdd <_cursor+0x2688f935>
    7f10:	d0 7f 0f             	sarb   $1,0xf(%edi)
    7f13:	01 16                	add    %edx,(%esi)
    7f15:	cb                   	lret
    7f16:	7e 0f                	jle    7f27 <pm_function_cb+0x28>
    7f18:	20 c0                	and    %al,%al
    7f1a:	0c 01                	or     $0x1,%al
    7f1c:	0f 22 c0             	mov    %eax,%cr0
    7f1f:	66 61                	popaw
    7f21:	66 60                	pushaw
    7f23:	ea 28 7f 08 00   	ljmp   $0xba66,$0x87f28

00007f28 <pm_function_cb_protected_mode>:
    7f28:	66 ba 10 00          	mov    $0x10,%dx
    7f2c:	8e da                	mov    %edx,%ds
    7f2e:	8e c2                	mov    %edx,%es
    7f30:	8e e2                	mov    %edx,%fs
    7f32:	8e ea                	mov    %edx,%gs
    7f34:	8e d2                	mov    %edx,%ss
    7f36:	bc 00 d0 07 00       	mov    $0x7d000,%esp
    7f3b:	e8 a4 00 00 00       	call   7fe4 <enable_NMI_32bit>
    7f40:	fb                   	sti
    7f41:	e8 2e 02 00 00       	call   8174 <bootloader_main>
    7f46:	fa                   	cli
    7f47:	e8 a1 00 00 00       	call   7fed <disabled_NMI_32bit>
    7f4c:	ea 53 7f 00 00 18 00 	ljmp   $0x18,$0x7f53

00007f53 <_pm_function_cb_disable_pm>:
    7f53:	66 b8 20 00          	mov    $0x20,%ax
    7f57:	8e d8                	mov    %eax,%ds
    7f59:	8e d0                	mov    %eax,%ss
    7f5b:	0f 20 c0             	mov    %cr0,%eax
    7f5e:	24 fe                	and    $0xfe,%al
    7f60:	0f 22 c0             	mov    %eax,%cr0
    7f63:	ea 6a 7f 00 00 00 00 	ljmp   $0x0,$0x7f6a

00007f6a <_pm_function_cb_real_mode>:
    7f6a:	31 c0                	xor    %eax,%eax
    7f6c:	8e d0                	mov    %eax,%ss
    7f6e:	8e d8                	mov    %eax,%ds
    7f70:	0f 01 1e             	lidtl  (%esi)
    7f73:	f9                   	stc
    7f74:	7e 8b                	jle    7f01 <pm_function_cb+0x2>
    7f76:	26 d0 7f e8          	sarb   $1,%es:-0x18(%edi)
    7f7a:	56                   	push   %esi
    7f7b:	00 fb                	add    %bh,%bl
    7f7d:	f8                   	clc
    7f7e:	66 61                	popaw
    7f80:	c3                   	ret

00007f81 <ENABLING_PM_MSG>:
    7f81:	45                   	inc    %ebp
    7f82:	6e                   	outsb  %ds:(%esi),(%dx)
    7f83:	61                   	popa
    7f84:	62 6c 69 6e          	bound  %ebp,0x6e(%ecx,%ebp,2)
    7f88:	67 20 70 72          	and    %dh,0x72(%bx,%si)
    7f8c:	6f                   	outsl  %ds:(%esi),(%dx)
    7f8d:	74 65                	je     7ff4 <disabled_NMI_32bit+0x7>
    7f8f:	63 74 65 64          	arpl   %esi,0x64(%ebp,%eiz,2)
    7f93:	20 6d 6f             	and    %ch,0x6f(%ebp)
    7f96:	64 65 2e 2e 2e 0d 0a 	fs gs cs cs cs or $0x3032410a,%eax
    7f9d:	   

00007f9d <A20_ENABLED_MSG>:
    7f9d:	41                   	inc    %ecx
    7f9e:	32 30                	xor    (%eax),%dh
    7fa0:	20 6c 69 6e          	and    %ch,0x6e(%ecx,%ebp,2)
    7fa4:	65 20 65 6e          	and    %ah,%gs:0x6e(%ebp)
    7fa8:	61                   	popa
    7fa9:	62 6c 65 64          	bound  %ebp,0x64(%ebp,%eiz,2)
    7fad:	21 0d 0a       	and    %ecx,0x756f430a

00007fb0 <A20_ERROR_MSG>:
    7fb0:	43                   	inc    %ebx
    7fb1:	6f                   	outsl  %ds:(%esi),(%dx)
    7fb2:	75 6c                	jne    8020 <enable_a20+0x2a>
    7fb4:	64 20 6e 6f          	and    %ch,%fs:0x6f(%esi)
    7fb8:	74 20                	je     7fda <enable_NMI+0x8>
    7fba:	65 6e                	outsb  %gs:(%esi),(%dx)
    7fbc:	61                   	popa
    7fbd:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
    7fc1:	74 68                	je     802b <enable_a20+0x35>
    7fc3:	65 20 41 32          	and    %al,%gs:0x32(%ecx)
    7fc7:	30 20                	xor    %ah,(%eax)
    7fc9:	6c                   	insb   (%dx),%es:(%edi)
    7fca:	69 6e 65 21 0d 0a  	imul   $0xa0d21,0x65(%esi),%ebp

00007fd0 <PREVIOUS_SP>:
	...

00007fd2 <enable_NMI>:
    7fd2:	e4 70                	in     $0x70,%al
    7fd4:	24 7f                	and    $0x7f,%al
    7fd6:	e6 70                	out    %al,$0x70
    7fd8:	e4 71                	in     $0x71,%al
    7fda:	c3                   	ret

00007fdb <disable_NMI>:
    7fdb:	e4 70                	in     $0x70,%al
    7fdd:	0c 80                	or     $0x80,%al
    7fdf:	e6 70                	out    %al,$0x70
    7fe1:	e4 71                	in     $0x71,%al
    7fe3:	c3                   	ret

00007fe4 <enable_NMI_32bit>:
    7fe4:	e4 70                	in     $0x70,%al
    7fe6:	24 7f                	and    $0x7f,%al
    7fe8:	e6 70                	out    %al,$0x70
    7fea:	e4 71                	in     $0x71,%al
    7fec:	c3                   	ret

00007fed <disabled_NMI_32bit>:
    7fed:	e4 70                	in     $0x70,%al
    7fef:	0c 80                	or     $0x80,%al
    7ff1:	e6 70                	out    %al,$0x70
    7ff3:	e4 71                	in     $0x71,%al
    7ff5:	c3                   	ret

00007ff6 <enable_a20>:
    7ff6:	fa                   	cli
    7ff7:	e8 2a 01 83 f8       	call   f8838126 <_cursor+0xf882fa7e>
    7ffc:	01 0f                	add    %ecx,(%edi)
    7ffe:	84 89 00 b8 03 24    	test   %cl,0x2403b800(%ecx)
    8004:	cd 15                	int    $0x15
    8006:	72 24                	jb     802c <_bios_a20_not_supported>
    8008:	84 e4                	test   %ah,%ah
    800a:	75 20                	jne    802c <_bios_a20_not_supported>
    800c:	b8 02 24 cd 15       	mov    $0x15cd2402,%eax
    8011:	72 19                	jb     802c <_bios_a20_not_supported>
    8013:	84 e4                	test   %ah,%ah
    8015:	75 15                	jne    802c <_bios_a20_not_supported>
    8017:	b8 01 00 84 c0       	mov    $0xc0840001,%eax
    801c:	75 6c                	jne    808a <_enable_a20_exit>
    801e:	b8 01 24 cd 15       	mov    $0x15cd2401,%eax
    8023:	72 07                	jb     802c <_bios_a20_not_supported>
    8025:	84 e4                	test   %ah,%ah
    8027:	b8 01 00 74 5e       	mov    $0x5e740001,%eax

0000802c <_bios_a20_not_supported>:
    802c:	be 8c 80 b9 4c       	mov    $0x4cb9808c,%esi
    8031:	00 e8                	add    %ch,%al
    8033:	8a fe                	mov    %dh,%bh
    8035:	e8 26 01 b0 ad       	call   adb08160 <_cursor+0xadaffab8>
    803a:	e6 64                	out    %al,$0x64
    803c:	e8 1f 01 b0 d0       	call   d0b08160 <_cursor+0xd0affab8>
    8041:	e6 64                	out    %al,$0x64
    8043:	e8 1f 01 e4 60       	call   60e48167 <_cursor+0x60e3fabf>
    8048:	50                   	push   %eax
    8049:	e8 12 01 b0 d1       	call   d1b08160 <_cursor+0xd1affab8>
    804e:	e6 64                	out    %al,$0x64
    8050:	e8 0b 01 58 0c       	call   c588160 <_cursor+0xc57fab8>
    8055:	02 e6                	add    %dh,%ah
    8057:	60                   	pusha
    8058:	e8 03 01 b0 ae       	call   aeb08160 <_cursor+0xaeaffab8>
    805d:	e6 64                	out    %al,$0x64
    805f:	e8 fc 00 e8 bf       	call   bfe88160 <_cursor+0xbfe7fab8>
    8064:	00 83 f8 01 74 20    	add    %al,0x207401f8(%ebx)

0000806a <_keyboard_controller_failed>:
    806a:	be d8 80 b9 4c       	mov    $0x4cb980d8,%esi
    806f:	00 e8                	add    %ch,%al
    8071:	4c                   	dec    %esp
    8072:	fe                   	(bad)
    8073:	e4 92                	in     $0x92,%al
    8075:	a8 02                	test   $0x2,%al
    8077:	75 06                	jne    807f <_after_fast_a20>
    8079:	0c 02                	or     $0x2,%al
    807b:	24 fe                	and    $0xfe,%al
    807d:	e6 92                	out    %al,$0x92

0000807f <_after_fast_a20>:
    807f:	e8 a2 00 83 f8       	call   f8838126 <_cursor+0xf882fa7e>
    8084:	01 74 03 b8          	add    %esi,-0x48(%ebx,%eax,1)
	...

0000808a <_enable_a20_exit>:
    808a:	fb                   	sti
    808b:	c3                   	ret

0000808c <BIOS_A20_ERROR_MSG>:
    808c:	42                   	inc    %edx
    808d:	49                   	dec    %ecx
    808e:	4f                   	dec    %edi
    808f:	53                   	push   %ebx
    8090:	20 41 32             	and    %al,0x32(%ecx)
    8093:	30 20                	xor    %ah,(%eax)
    8095:	6e                   	outsb  %ds:(%esi),(%dx)
    8096:	6f                   	outsl  %ds:(%esi),(%dx)
    8097:	74 20                	je     80b9 <BIOS_A20_ERROR_MSG+0x2d>
    8099:	73 75                	jae    8110 <KEYBOARD_A20_FAILED_MSG+0x38>
    809b:	70 70                	jo     810d <KEYBOARD_A20_FAILED_MSG+0x35>
    809d:	6f                   	outsl  %ds:(%esi),(%dx)
    809e:	72 74                	jb     8114 <KEYBOARD_A20_FAILED_MSG+0x3c>
    80a0:	65 64 20 6f 72       	gs and %ch,%fs:0x72(%edi)
    80a5:	20 61 6e             	and    %ah,0x6e(%ecx)
    80a8:	20 65 72             	and    %ah,0x72(%ebp)
    80ab:	72 6f                	jb     811c <KEYBOARD_A20_FAILED_MSG+0x44>
    80ad:	72 20                	jb     80cf <BIOS_A20_ERROR_MSG+0x43>
    80af:	6f                   	outsl  %ds:(%esi),(%dx)
    80b0:	63 63 75             	arpl   %esp,0x75(%ebx)
    80b3:	72 65                	jb     811a <KEYBOARD_A20_FAILED_MSG+0x42>
    80b5:	64 21 0d 0a 54 72 79 	and    %ecx,%fs:0x7972540a
    80bc:	69 6e 67 20 6b 65 79 	imul   $0x79656b20,0x67(%esi),%ebp
    80c3:	62 6f 61             	bound  %ebp,0x61(%edi)
    80c6:	72 64                	jb     812c <check_a20+0x8>
    80c8:	20 63 6f             	and    %ah,0x6f(%ebx)
    80cb:	6e                   	outsb  %ds:(%esi),(%dx)
    80cc:	74 72                	je     8140 <check_a20+0x1c>
    80ce:	6f                   	outsl  %ds:(%esi),(%dx)
    80cf:	6c                   	insb   (%dx),%es:(%edi)
    80d0:	6c                   	insb   (%dx),%es:(%edi)
    80d1:	65 72 2e             	gs jb  8102 <KEYBOARD_A20_FAILED_MSG+0x2a>
    80d4:	2e 2e 0d 0a    	cs cs or $0x6961460a,%eax

000080d8 <KEYBOARD_A20_FAILED_MSG>:
    80d8:	46                   	inc    %esi
    80d9:	61                   	popa
    80da:	69 6c 65 64 20 74 6f 	imul   $0x206f7420,0x64(%ebp,%eiz,2),%ebp
    80e1:	20 
    80e2:	65 6e                	outsb  %gs:(%esi),(%dx)
    80e4:	61                   	popa
    80e5:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
    80e9:	41                   	inc    %ecx
    80ea:	32 30                	xor    (%eax),%dh
    80ec:	20 75 73             	and    %dh,0x73(%ebp)
    80ef:	69 6e 67 20 6b 65 79 	imul   $0x79656b20,0x67(%esi),%ebp
    80f6:	62 6f 61             	bound  %ebp,0x61(%edi)
    80f9:	72 64                	jb     815f <a20_wait+0x1>
    80fb:	20 63 6f             	and    %ah,0x6f(%ebx)
    80fe:	6e                   	outsb  %ds:(%esi),(%dx)
    80ff:	74 72                	je     8173 <BOOTLOADER_RET_VALUE+0x3>
    8101:	6f                   	outsl  %ds:(%esi),(%dx)
    8102:	6c                   	insb   (%dx),%es:(%edi)
    8103:	6c                   	insb   (%dx),%es:(%edi)
    8104:	65 72 21             	gs jb  8128 <check_a20+0x4>
    8107:	0d 0a 54 72 79       	or     $0x7972540a,%eax
    810c:	69 6e 67 20 46 61 73 	imul   $0x73614620,0x67(%esi),%ebp
    8113:	74 20                	je     8135 <check_a20+0x11>
    8115:	41                   	inc    %ecx
    8116:	32 30                	xor    (%eax),%dh
    8118:	20 6d 65             	and    %ch,0x65(%ebp)
    811b:	74 68                	je     8185 <bootloader_main+0x11>
    811d:	6f                   	outsl  %ds:(%esi),(%dx)
    811e:	64 2e 2e 2e 0d 0a  	fs cs cs cs or $0x61e9c0a,%eax
    8125:	  

00008124 <check_a20>:
    8124:	9c                   	pushf
    8125:	1e                   	push   %ds
    8126:	06                   	push   %es
    8127:	56                   	push   %esi
    8128:	57                   	push   %edi
    8129:	31 c0                	xor    %eax,%eax
    812b:	8e c0                	mov    %eax,%es
    812d:	bf 00 05 f7 d0       	mov    $0xd0f70500,%edi
    8132:	8e d8                	mov    %eax,%ds
    8134:	be 10 05 26 8a       	mov    $0x8a260510,%esi
    8139:	05 50 8a 04 50       	add    $0x50048a50,%eax
    813e:	26 c6 05 00 c6 04 ff 	movb   $0x26,%es:0xff04c600
    8145:	26 
    8146:	80 3d ff 58 88 04 58 	cmpb   $0x58,0x48858ff
    814d:	26 88 05 b8 00 00 74 	mov    %al,%es:0x740000b8
    8154:	03 b8 01 00      	add    0x5e5f0001(%eax),%edi

00008158 <_check_a20_exit>:
    8158:	5f                   	pop    %edi
    8159:	5e                   	pop    %esi
    815a:	07                   	pop    %es
    815b:	1f                   	pop    %ds
    815c:	9d                   	popf
    815d:	c3                   	ret

0000815e <a20_wait>:
    815e:	e4 64                	in     $0x64,%al
    8160:	a8 02                	test   $0x2,%al
    8162:	75 fa                	jne    815e <a20_wait>
    8164:	c3                   	ret

00008165 <a20_wait_response>:
    8165:	e4 64                	in     $0x64,%al
    8167:	a8 01                	test   $0x1,%al
    8169:	74 fa                	je     8165 <a20_wait_response>
    816b:	c3                   	ret

0000816c <BOOTLOADER_ARG>:
    816c:	00 02                	add    %al,(%edx)
	...

00008170 <BOOTLOADER_RET_VALUE>:
    8170:	00 00                	add    %al,(%eax)
	...

00008174 <bootloader_main>:
    8174:	55                   	push   %ebp
    8175:	89 e5                	mov    %esp,%ebp
    8177:	83 ec 18             	sub    $0x18,%esp
    817a:	c7 45 f4 24 86 00 00 	movl   $0x8624,-0xc(%ebp)
    8181:	e8 87 00 00 00       	call   820d <VGA_ClearScreen>
    8186:	83 ec 0c             	sub    $0xc,%esp
    8189:	ff 75 f4             	push   -0xc(%ebp)
    818c:	e8 22 02 00 00       	call   83b3 <VGA_Print>
    8191:	83 c4 10             	add    $0x10,%esp
    8194:	83 ec 0c             	sub    $0xc,%esp
    8197:	68 00 80 0b 00       	push   $0xb8000
    819c:	68 4e 86 00 00       	push   $0x864e
    81a1:	6a 69                	push   $0x69
    81a3:	6a 05                	push   $0x5
    81a5:	68 5c 86 00 00       	push   $0x865c
    81aa:	e8 65 03 00 00       	call   8514 <VGA_Printf>
    81af:	83 c4 20             	add    $0x20,%esp
    81b2:	90                   	nop
    81b3:	c9                   	leave
    81b4:	c3                   	ret

000081b5 <VGA_SetCursor>:
    81b5:	55                   	push   %ebp
    81b6:	89 e5                	mov    %esp,%ebp
    81b8:	8b 45 08             	mov    0x8(%ebp),%eax
    81bb:	8b 55 0c             	mov    0xc(%ebp),%edx
    81be:	a3 a8 86 00 00       	mov    %eax,0x86a8
    81c3:	89 15 ac 86 00 00    	mov    %edx,0x86ac
    81c9:	90                   	nop
    81ca:	5d                   	pop    %ebp
    81cb:	c3                   	ret

000081cc <VGA_GetCursor>:
    81cc:	55                   	push   %ebp
    81cd:	89 e5                	mov    %esp,%ebp
    81cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
    81d2:	a1 a8 86 00 00       	mov    0x86a8,%eax
    81d7:	8b 15 ac 86 00 00    	mov    0x86ac,%edx
    81dd:	89 01                	mov    %eax,(%ecx)
    81df:	89 51 04             	mov    %edx,0x4(%ecx)
    81e2:	8b 45 08             	mov    0x8(%ebp),%eax
    81e5:	5d                   	pop    %ebp
    81e6:	c2 04 00             	ret    $0x4

000081e9 <VGA_SetColorAttributes>:
    81e9:	55                   	push   %ebp
    81ea:	89 e5                	mov    %esp,%ebp
    81ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    81ef:	c1 e0 04             	shl    $0x4,%eax
    81f2:	89 c2                	mov    %eax,%edx
    81f4:	8b 45 08             	mov    0x8(%ebp),%eax
    81f7:	09 d0                	or     %edx,%eax
    81f9:	a2 a7 86 00 00       	mov    %al,0x86a7
    81fe:	90                   	nop
    81ff:	5d                   	pop    %ebp
    8200:	c3                   	ret

00008201 <VGA_GetColorAttributes>:
    8201:	55                   	push   %ebp
    8202:	89 e5                	mov    %esp,%ebp
    8204:	0f b6 05 a7 86 00 00 	movzbl 0x86a7,%eax
    820b:	5d                   	pop    %ebp
    820c:	c3                   	ret

0000820d <VGA_ClearScreen>:
    820d:	55                   	push   %ebp
    820e:	89 e5                	mov    %esp,%ebp
    8210:	83 ec 10             	sub    $0x10,%esp
    8213:	0f b6 05 a7 86 00 00 	movzbl 0x86a7,%eax
    821a:	0f b6 c0             	movzbl %al,%eax
    821d:	c1 e0 08             	shl    $0x8,%eax
    8220:	83 c8 20             	or     $0x20,%eax
    8223:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    8227:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    822e:	eb 17                	jmp    8247 <VGA_ClearScreen+0x3a>
    8230:	ba 00 80 0b 00       	mov    $0xb8000,%edx
    8235:	8b 45 fc             	mov    -0x4(%ebp),%eax
    8238:	01 c0                	add    %eax,%eax
    823a:	01 c2                	add    %eax,%edx
    823c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    8240:	66 89 02             	mov    %ax,(%edx)
    8243:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    8247:	ba 50 00 00 00       	mov    $0x50,%edx
    824c:	b8 19 00 00 00       	mov    $0x19,%eax
    8251:	0f af c2             	imul   %edx,%eax
    8254:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    8257:	7c d7                	jl     8230 <VGA_ClearScreen+0x23>
    8259:	c7 05 a8 86 00 00 00 	movl   $0x0,0x86a8
    8260:	00 00 00 
    8263:	c7 05 ac 86 00 00 00 	movl   $0x0,0x86ac
    826a:	00 00 00 
    826d:	90                   	nop
    826e:	c9                   	leave
    826f:	c3                   	ret

00008270 <VGA_ScrollScreen>:
    8270:	55                   	push   %ebp
    8271:	89 e5                	mov    %esp,%ebp
    8273:	53                   	push   %ebx
    8274:	83 ec 10             	sub    $0x10,%esp
    8277:	c7 45 f8 50 00 00 00 	movl   $0x50,-0x8(%ebp)
    827e:	eb 29                	jmp    82a9 <VGA_ScrollScreen+0x39>
    8280:	ba 00 80 0b 00       	mov    $0xb8000,%edx
    8285:	8b 45 f8             	mov    -0x8(%ebp),%eax
    8288:	01 c0                	add    %eax,%eax
    828a:	01 d0                	add    %edx,%eax
    828c:	bb 00 80 0b 00       	mov    $0xb8000,%ebx
    8291:	b9 50 00 00 00       	mov    $0x50,%ecx
    8296:	8b 55 f8             	mov    -0x8(%ebp),%edx
    8299:	29 ca                	sub    %ecx,%edx
    829b:	01 d2                	add    %edx,%edx
    829d:	01 da                	add    %ebx,%edx
    829f:	0f b7 00             	movzwl (%eax),%eax
    82a2:	66 89 02             	mov    %ax,(%edx)
    82a5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    82a9:	ba 50 00 00 00       	mov    $0x50,%edx
    82ae:	b8 19 00 00 00       	mov    $0x19,%eax
    82b3:	0f af c2             	imul   %edx,%eax
    82b6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    82b9:	7c c5                	jl     8280 <VGA_ScrollScreen+0x10>
    82bb:	a1 a8 86 00 00       	mov    0x86a8,%eax
    82c0:	83 e8 01             	sub    $0x1,%eax
    82c3:	a3 a8 86 00 00       	mov    %eax,0x86a8
    82c8:	a1 a8 86 00 00       	mov    0x86a8,%eax
    82cd:	85 c0                	test   %eax,%eax
    82cf:	79 14                	jns    82e5 <VGA_ScrollScreen+0x75>
    82d1:	c7 05 a8 86 00 00 00 	movl   $0x0,0x86a8
    82d8:	00 00 00 
    82db:	c7 05 ac 86 00 00 00 	movl   $0x0,0x86ac
    82e2:	00 00 00 
    82e5:	90                   	nop
    82e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    82e9:	c9                   	leave
    82ea:	c3                   	ret

000082eb <VGA_PutChar>:
    82eb:	55                   	push   %ebp
    82ec:	89 e5                	mov    %esp,%ebp
    82ee:	83 ec 10             	sub    $0x10,%esp
    82f1:	80 7d 08 0a          	cmpb   $0xa,0x8(%ebp)
    82f5:	75 33                	jne    832a <VGA_PutChar+0x3f>
    82f7:	a1 a8 86 00 00       	mov    0x86a8,%eax
    82fc:	83 c0 01             	add    $0x1,%eax
    82ff:	a3 a8 86 00 00       	mov    %eax,0x86a8
    8304:	c7 05 ac 86 00 00 00 	movl   $0x0,0x86ac
    830b:	00 00 00 
    830e:	a1 a8 86 00 00       	mov    0x86a8,%eax
    8313:	ba 19 00 00 00       	mov    $0x19,%edx
    8318:	39 d0                	cmp    %edx,%eax
    831a:	0f 8c 90 00 00 00    	jl     83b0 <VGA_PutChar+0xc5>
    8320:	e8 4b ff ff ff       	call   8270 <VGA_ScrollScreen>
    8325:	e9 86 00 00 00       	jmp    83b0 <VGA_PutChar+0xc5>
    832a:	0f b6 05 a7 86 00 00 	movzbl 0x86a7,%eax
    8331:	0f b6 c0             	movzbl %al,%eax
    8334:	c1 e0 08             	shl    $0x8,%eax
    8337:	89 c2                	mov    %eax,%edx
    8339:	66 0f be 45 08       	movsbw 0x8(%ebp),%ax
    833e:	09 d0                	or     %edx,%eax
    8340:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    8344:	b9 00 80 0b 00       	mov    $0xb8000,%ecx
    8349:	a1 a8 86 00 00       	mov    0x86a8,%eax
    834e:	ba 50 00 00 00       	mov    $0x50,%edx
    8353:	0f af d0             	imul   %eax,%edx
    8356:	a1 ac 86 00 00       	mov    0x86ac,%eax
    835b:	01 d0                	add    %edx,%eax
    835d:	01 c0                	add    %eax,%eax
    835f:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    8362:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    8366:	66 89 02             	mov    %ax,(%edx)
    8369:	a1 ac 86 00 00       	mov    0x86ac,%eax
    836e:	83 c0 01             	add    $0x1,%eax
    8371:	a3 ac 86 00 00       	mov    %eax,0x86ac
    8376:	a1 ac 86 00 00       	mov    0x86ac,%eax
    837b:	ba 50 00 00 00       	mov    $0x50,%edx
    8380:	39 d0                	cmp    %edx,%eax
    8382:	7c 2d                	jl     83b1 <VGA_PutChar+0xc6>
    8384:	c7 05 ac 86 00 00 00 	movl   $0x0,0x86ac
    838b:	00 00 00 
    838e:	a1 a8 86 00 00       	mov    0x86a8,%eax
    8393:	83 c0 01             	add    $0x1,%eax
    8396:	a3 a8 86 00 00       	mov    %eax,0x86a8
    839b:	a1 a8 86 00 00       	mov    0x86a8,%eax
    83a0:	ba 19 00 00 00       	mov    $0x19,%edx
    83a5:	39 d0                	cmp    %edx,%eax
    83a7:	7c 08                	jl     83b1 <VGA_PutChar+0xc6>
    83a9:	e8 c2 fe ff ff       	call   8270 <VGA_ScrollScreen>
    83ae:	eb 01                	jmp    83b1 <VGA_PutChar+0xc6>
    83b0:	90                   	nop
    83b1:	c9                   	leave
    83b2:	c3                   	ret

000083b3 <VGA_Print>:
    83b3:	55                   	push   %ebp
    83b4:	89 e5                	mov    %esp,%ebp
    83b6:	83 ec 10             	sub    $0x10,%esp
    83b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    83c0:	eb 1b                	jmp    83dd <VGA_Print+0x2a>
    83c2:	8b 55 08             	mov    0x8(%ebp),%edx
    83c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    83c8:	01 d0                	add    %edx,%eax
    83ca:	0f b6 00             	movzbl (%eax),%eax
    83cd:	0f be c0             	movsbl %al,%eax
    83d0:	50                   	push   %eax
    83d1:	e8 15 ff ff ff       	call   82eb <VGA_PutChar>
    83d6:	83 c4 04             	add    $0x4,%esp
    83d9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    83dd:	8b 55 08             	mov    0x8(%ebp),%edx
    83e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    83e3:	01 d0                	add    %edx,%eax
    83e5:	0f b6 00             	movzbl (%eax),%eax
    83e8:	84 c0                	test   %al,%al
    83ea:	75 d6                	jne    83c2 <VGA_Print+0xf>
    83ec:	90                   	nop
    83ed:	90                   	nop
    83ee:	c9                   	leave
    83ef:	c3                   	ret

000083f0 <VGA_PrintInt>:
    83f0:	55                   	push   %ebp
    83f1:	89 e5                	mov    %esp,%ebp
    83f3:	83 ec 20             	sub    $0x20,%esp
    83f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    83fa:	75 0f                	jne    840b <VGA_PrintInt+0x1b>
    83fc:	6a 30                	push   $0x30
    83fe:	e8 e8 fe ff ff       	call   82eb <VGA_PutChar>
    8403:	83 c4 04             	add    $0x4,%esp
    8406:	e9 ad 00 00 00       	jmp    84b8 <VGA_PrintInt+0xc8>
    840b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    840f:	79 0f                	jns    8420 <VGA_PrintInt+0x30>
    8411:	6a 2d                	push   $0x2d
    8413:	e8 d3 fe ff ff       	call   82eb <VGA_PutChar>
    8418:	83 c4 04             	add    $0x4,%esp
    841b:	e9 98 00 00 00       	jmp    84b8 <VGA_PrintInt+0xc8>
    8420:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    8427:	eb 57                	jmp    8480 <VGA_PrintInt+0x90>
    8429:	8b 4d 08             	mov    0x8(%ebp),%ecx
    842c:	ba 67 66 66 66       	mov    $0x66666667,%edx
    8431:	89 c8                	mov    %ecx,%eax
    8433:	f7 ea                	imul   %edx
    8435:	c1 fa 02             	sar    $0x2,%edx
    8438:	89 c8                	mov    %ecx,%eax
    843a:	c1 f8 1f             	sar    $0x1f,%eax
    843d:	29 c2                	sub    %eax,%edx
    843f:	89 d0                	mov    %edx,%eax
    8441:	c1 e0 02             	shl    $0x2,%eax
    8444:	01 d0                	add    %edx,%eax
    8446:	01 c0                	add    %eax,%eax
    8448:	29 c1                	sub    %eax,%ecx
    844a:	89 ca                	mov    %ecx,%edx
    844c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    844f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    8452:	ba 67 66 66 66       	mov    $0x66666667,%edx
    8457:	89 c8                	mov    %ecx,%eax
    8459:	f7 ea                	imul   %edx
    845b:	89 d0                	mov    %edx,%eax
    845d:	c1 f8 02             	sar    $0x2,%eax
    8460:	c1 f9 1f             	sar    $0x1f,%ecx
    8463:	89 ca                	mov    %ecx,%edx
    8465:	29 d0                	sub    %edx,%eax
    8467:	89 45 08             	mov    %eax,0x8(%ebp)
    846a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    846d:	83 c0 30             	add    $0x30,%eax
    8470:	89 c1                	mov    %eax,%ecx
    8472:	8d 55 ea             	lea    -0x16(%ebp),%edx
    8475:	8b 45 fc             	mov    -0x4(%ebp),%eax
    8478:	01 d0                	add    %edx,%eax
    847a:	88 08                	mov    %cl,(%eax)
    847c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    8480:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    8484:	74 06                	je     848c <VGA_PrintInt+0x9c>
    8486:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
    848a:	7e 9d                	jle    8429 <VGA_PrintInt+0x39>
    848c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    848f:	83 e8 01             	sub    $0x1,%eax
    8492:	89 45 f8             	mov    %eax,-0x8(%ebp)
    8495:	eb 1b                	jmp    84b2 <VGA_PrintInt+0xc2>
    8497:	8d 55 ea             	lea    -0x16(%ebp),%edx
    849a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    849d:	01 d0                	add    %edx,%eax
    849f:	0f b6 00             	movzbl (%eax),%eax
    84a2:	0f be c0             	movsbl %al,%eax
    84a5:	50                   	push   %eax
    84a6:	e8 40 fe ff ff       	call   82eb <VGA_PutChar>
    84ab:	83 c4 04             	add    $0x4,%esp
    84ae:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
    84b2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
    84b6:	79 df                	jns    8497 <VGA_PrintInt+0xa7>
    84b8:	c9                   	leave
    84b9:	c3                   	ret

000084ba <VGA_PrintPointer>:
    84ba:	55                   	push   %ebp
    84bb:	89 e5                	mov    %esp,%ebp
    84bd:	83 ec 10             	sub    $0x10,%esp
    84c0:	68 a4 86 00 00       	push   $0x86a4
    84c5:	e8 e9 fe ff ff       	call   83b3 <VGA_Print>
    84ca:	83 c4 04             	add    $0x4,%esp
    84cd:	c6 45 ff 07          	movb   $0x7,-0x1(%ebp)
    84d1:	eb 37                	jmp    850a <VGA_PrintPointer+0x50>
    84d3:	8b 45 08             	mov    0x8(%ebp),%eax
    84d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    84d9:	0f be 45 ff          	movsbl -0x1(%ebp),%eax
    84dd:	c1 e0 02             	shl    $0x2,%eax
    84e0:	89 c1                	mov    %eax,%ecx
    84e2:	d3 6d f8             	shrl   %cl,-0x8(%ebp)
    84e5:	83 65 f8 0f          	andl   $0xf,-0x8(%ebp)
    84e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    84ec:	05 94 86 00 00       	add    $0x8694,%eax
    84f1:	0f b6 00             	movzbl (%eax),%eax
    84f4:	0f be c0             	movsbl %al,%eax
    84f7:	50                   	push   %eax
    84f8:	e8 ee fd ff ff       	call   82eb <VGA_PutChar>
    84fd:	83 c4 04             	add    $0x4,%esp
    8500:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    8504:	83 e8 01             	sub    $0x1,%eax
    8507:	88 45 ff             	mov    %al,-0x1(%ebp)
    850a:	80 7d ff 00          	cmpb   $0x0,-0x1(%ebp)
    850e:	79 c3                	jns    84d3 <VGA_PrintPointer+0x19>
    8510:	90                   	nop
    8511:	90                   	nop
    8512:	c9                   	leave
    8513:	c3                   	ret

00008514 <VGA_Printf>:
    8514:	55                   	push   %ebp
    8515:	89 e5                	mov    %esp,%ebp
    8517:	83 ec 20             	sub    $0x20,%esp
    851a:	8d 45 0c             	lea    0xc(%ebp),%eax
    851d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    8520:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    8527:	e9 e1 00 00 00       	jmp    860d <VGA_Printf+0xf9>
    852c:	8b 55 08             	mov    0x8(%ebp),%edx
    852f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    8532:	01 d0                	add    %edx,%eax
    8534:	0f b6 00             	movzbl (%eax),%eax
    8537:	0f be c0             	movsbl %al,%eax
    853a:	83 f8 25             	cmp    $0x25,%eax
    853d:	0f 85 ac 00 00 00    	jne    85ef <VGA_Printf+0xdb>
    8543:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    8547:	8b 55 08             	mov    0x8(%ebp),%edx
    854a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    854d:	01 d0                	add    %edx,%eax
    854f:	0f b6 00             	movzbl (%eax),%eax
    8552:	0f be c0             	movsbl %al,%eax
    8555:	83 f8 73             	cmp    $0x73,%eax
    8558:	74 79                	je     85d3 <VGA_Printf+0xbf>
    855a:	83 f8 73             	cmp    $0x73,%eax
    855d:	0f 8f a5 00 00 00    	jg     8608 <VGA_Printf+0xf4>
    8563:	83 f8 70             	cmp    $0x70,%eax
    8566:	74 50                	je     85b8 <VGA_Printf+0xa4>
    8568:	83 f8 70             	cmp    $0x70,%eax
    856b:	0f 8f 97 00 00 00    	jg     8608 <VGA_Printf+0xf4>
    8571:	83 f8 63             	cmp    $0x63,%eax
    8574:	74 0a                	je     8580 <VGA_Printf+0x6c>
    8576:	83 f8 64             	cmp    $0x64,%eax
    8579:	74 22                	je     859d <VGA_Printf+0x89>
    857b:	e9 88 00 00 00       	jmp    8608 <VGA_Printf+0xf4>
    8580:	8b 45 e8             	mov    -0x18(%ebp),%eax
    8583:	8d 50 04             	lea    0x4(%eax),%edx
    8586:	89 55 e8             	mov    %edx,-0x18(%ebp)
    8589:	8b 00                	mov    (%eax),%eax
    858b:	88 45 ef             	mov    %al,-0x11(%ebp)
    858e:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
    8592:	50                   	push   %eax
    8593:	e8 53 fd ff ff       	call   82eb <VGA_PutChar>
    8598:	83 c4 04             	add    $0x4,%esp
    859b:	eb 50                	jmp    85ed <VGA_Printf+0xd9>
    859d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    85a0:	8d 50 04             	lea    0x4(%eax),%edx
    85a3:	89 55 e8             	mov    %edx,-0x18(%ebp)
    85a6:	8b 00                	mov    (%eax),%eax
    85a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    85ab:	ff 75 f0             	push   -0x10(%ebp)
    85ae:	e8 3d fe ff ff       	call   83f0 <VGA_PrintInt>
    85b3:	83 c4 04             	add    $0x4,%esp
    85b6:	eb 35                	jmp    85ed <VGA_Printf+0xd9>
    85b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    85bb:	8d 50 04             	lea    0x4(%eax),%edx
    85be:	89 55 e8             	mov    %edx,-0x18(%ebp)
    85c1:	8b 00                	mov    (%eax),%eax
    85c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    85c6:	ff 75 f4             	push   -0xc(%ebp)
    85c9:	e8 ec fe ff ff       	call   84ba <VGA_PrintPointer>
    85ce:	83 c4 04             	add    $0x4,%esp
    85d1:	eb 1a                	jmp    85ed <VGA_Printf+0xd9>
    85d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    85d6:	8d 50 04             	lea    0x4(%eax),%edx
    85d9:	89 55 e8             	mov    %edx,-0x18(%ebp)
    85dc:	8b 00                	mov    (%eax),%eax
    85de:	89 45 f8             	mov    %eax,-0x8(%ebp)
    85e1:	ff 75 f8             	push   -0x8(%ebp)
    85e4:	e8 ca fd ff ff       	call   83b3 <VGA_Print>
    85e9:	83 c4 04             	add    $0x4,%esp
    85ec:	90                   	nop
    85ed:	eb 19                	jmp    8608 <VGA_Printf+0xf4>
    85ef:	8b 55 08             	mov    0x8(%ebp),%edx
    85f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    85f5:	01 d0                	add    %edx,%eax
    85f7:	0f b6 00             	movzbl (%eax),%eax
    85fa:	0f be c0             	movsbl %al,%eax
    85fd:	50                   	push   %eax
    85fe:	e8 e8 fc ff ff       	call   82eb <VGA_PutChar>
    8603:	83 c4 04             	add    $0x4,%esp
    8606:	eb 01                	jmp    8609 <VGA_Printf+0xf5>
    8608:	90                   	nop
    8609:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    860d:	8b 55 08             	mov    0x8(%ebp),%edx
    8610:	8b 45 fc             	mov    -0x4(%ebp),%eax
    8613:	01 d0                	add    %edx,%eax
    8615:	0f b6 00             	movzbl (%eax),%eax
    8618:	84 c0                	test   %al,%al
    861a:	0f 85 0c ff ff ff    	jne    852c <VGA_Printf+0x18>
    8620:	90                   	nop
    8621:	90                   	nop
    8622:	c9                   	leave
    8623:	c3                   	ret

Disassembly of section .rodata:

00008624 <SCREEN_WIDTH-0x64>:
    8624:	50                   	push   %eax
    8625:	72 6f                	jb     8696 <HEX_CHARS+0x2>
    8627:	74 65                	je     868e <SCREEN_HEIGHT+0x2>
    8629:	63 74 65 64          	arpl   %esi,0x64(%ebp,%eiz,2)
    862d:	20 6d 6f             	and    %ch,0x6f(%ebp)
    8630:	64 65 20 65 6e       	fs and %ah,%gs:0x6e(%ebp)
    8635:	61                   	popa
    8636:	62 6c 65 64          	bound  %ebp,0x64(%ebp,%eiz,2)
    863a:	20 61 6e             	and    %ah,0x6e(%ecx)
    863d:	64 20 72 75          	and    %dh,%fs:0x75(%edx)
    8641:	6e                   	outsb  %ds:(%esi),(%dx)
    8642:	6e                   	outsb  %ds:(%esi),(%dx)
    8643:	69 6e 67 20 69 6e 20 	imul   $0x206e6920,0x67(%esi),%ebp
    864a:	43                   	inc    %ebx
    864b:	21 0a                	and    %ecx,(%edx)
    864d:	00 48 65             	add    %cl,0x65(%eax)
    8650:	6c                   	insb   (%dx),%es:(%edi)
    8651:	6c                   	insb   (%dx),%es:(%edi)
    8652:	6f                   	outsl  %ds:(%esi),(%dx)
    8653:	20 57 6f             	and    %dl,0x6f(%edi)
    8656:	72 6c                	jb     86c4 <_cursor+0x1c>
    8658:	64 21 00             	and    %eax,%fs:(%eax)
    865b:	00 49 6e             	add    %cl,0x6e(%ecx)
    865e:	74 3a                	je     869a <HEX_CHARS+0x6>
    8660:	20 25 64 0a 43 68    	and    %ah,0x68430a64
    8666:	61                   	popa
    8667:	72 3a                	jb     86a3 <HEX_CHARS+0xf>
    8669:	20 25 63 0a 53 74    	and    %ah,0x74530a63
    866f:	72 69                	jb     86da <_cursor+0x32>
    8671:	6e                   	outsb  %ds:(%esi),(%dx)
    8672:	67 3a 20             	cmp    (%bx,%si),%ah
    8675:	25 73 0a 50 6f       	and    $0x6f500a73,%eax
    867a:	69 6e 74 65 72 3a 20 	imul   $0x203a7265,0x74(%esi),%ebp
    8681:	25 70 0a 00 00       	and    $0xa70,%eax
	...

00008688 <SCREEN_WIDTH>:
    8688:	50                   	push   %eax
    8689:	00 00                	add    %al,(%eax)
	...

0000868c <SCREEN_HEIGHT>:
    868c:	19 00                	sbb    %eax,(%eax)
	...

00008690 <VGA_FRAMEBUFFER>:
    8690:	00 80 0b 00      	add    %al,0x3130000b(%eax)

00008694 <HEX_CHARS>:
    8694:	30 31                	xor    %dh,(%ecx)
    8696:	32 33                	xor    (%ebx),%dh
    8698:	34 35                	xor    $0x35,%al
    869a:	36 37                	ss aaa
    869c:	38 39                	cmp    %bh,(%ecx)
    869e:	41                   	inc    %ecx
    869f:	42                   	inc    %edx
    86a0:	43                   	inc    %ebx
    86a1:	44                   	inc    %esp
    86a2:	45                   	inc    %ebp
    86a3:	46                   	inc    %esi
    86a4:	30 78 00             	xor    %bh,0x0(%eax)

Disassembly of section .data:

000086a7 <VGA_COLOR_ATTRIBUTE>:
    86a7:	07                   	pop    %es

Disassembly of section .padding:

000089fe <.padding>:
    89fe:	aa                   	stos   %al,%es:(%edi)
    89ff:	55                   	push   %ebp

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	7a 01                	jp     3 <A20_ENABLED_MSG_LEN-0x10>
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	7b 00                	jnp    8 <A20_ENABLED_MSG_LEN-0xb>
   8:	00 00                	add    %al,(%eax)
   a:	01 01                	add    %eax,(%ecx)
   c:	fb                   	sti
   d:	0e                   	push   %cs
   e:	0a 00                	or     (%eax),%al
  10:	01 01                	add    %eax,(%ecx)
  12:	01 01                	add    %eax,(%ecx)
  14:	00 00                	add    %al,(%eax)
  16:	00 01                	add    %al,(%ecx)
  18:	2f                   	das
  19:	68 6f 6d 65 2f       	push   $0x2f656d6f
  1e:	6a 63                	push   $0x63
  20:	68 61 75 2f 44       	push   $0x442f7561
  25:	6f                   	outsl  %ds:(%esi),(%dx)
  26:	63 75 6d             	arpl   %esi,0x6d(%ebp)
  29:	65 6e                	outsb  %gs:(%esi),(%dx)
  2b:	74 73                	je     a0 <BIOS_A20_ERROR_MSG_LEN+0x54>
  2d:	2f                   	das
  2e:	47                   	inc    %edi
  2f:	69 74 48 75 62 2f 53 	imul   $0x74532f62,0x75(%eax,%ecx,2),%esi
  36:	74 
  37:	65 69 6e 65 72 4f 53 	imul   $0x2f534f72,%gs:0x65(%esi),%ebp
  3e:	2f 
  3f:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  42:	74 2f                	je     73 <BIOS_A20_ERROR_MSG_LEN+0x27>
  44:	62 69 6f             	bound  %ebp,0x6f(%ecx)
  47:	73 2f                	jae    78 <BIOS_A20_ERROR_MSG_LEN+0x2c>
  49:	73 74                	jae    bf <BIOS_A20_ERROR_MSG_LEN+0x73>
  4b:	61                   	popa
  4c:	67 65 32 00          	xor    %gs:(%bx,%si),%al
  50:	00 73 65             	add    %dh,0x65(%ebx)
  53:	63 6f 6e             	arpl   %ebp,0x6e(%edi)
  56:	64 5f                	fs pop %edi
  58:	73 74                	jae    ce <BIOS_A20_ERROR_MSG_LEN+0x82>
  5a:	61                   	popa
  5b:	67 65 2e 73 00       	addr16 gs jae,pn 60 <BIOS_A20_ERROR_MSG_LEN+0x14>
  60:	01 00                	add    %eax,(%eax)
  62:	00 70 6d             	add    %dh,0x6d(%eax)
  65:	5f                   	pop    %edi
  66:	66 75 6e             	data16 jne d7 <BIOS_A20_ERROR_MSG_LEN+0x8b>
  69:	63 74 69 6f          	arpl   %esi,0x6f(%ecx,%ebp,2)
  6d:	6e                   	outsb  %ds:(%esi),(%dx)
  6e:	5f                   	pop    %edi
  6f:	63 61 6c             	arpl   %esp,0x6c(%ecx)
  72:	6c                   	insb   (%dx),%es:(%edi)
  73:	65 72 2e             	gs jb  a4 <BIOS_A20_ERROR_MSG_LEN+0x58>
  76:	73 00                	jae    78 <BIOS_A20_ERROR_MSG_LEN+0x2c>
  78:	01 00                	add    %eax,(%eax)
  7a:	00 61 32             	add    %ah,0x32(%ecx)
  7d:	30 2e                	xor    %ch,(%esi)
  7f:	73 00                	jae    81 <BIOS_A20_ERROR_MSG_LEN+0x35>
  81:	01 00                	add    %eax,(%eax)
  83:	00 00                	add    %al,(%eax)
  85:	00 05 02 00 7e 00    	add    %al,0x7e0002
  8b:	00 15 4b 2c 2c 2e    	add    %dl,0x2e2c2c4b
  91:	3a 2c 2e             	cmp    (%esi,%ebp,1),%ch
  94:	3a 3a                	cmp    (%edx),%bh
  96:	2f                   	das
  97:	3b 3a                	cmp    (%edx),%edi
  99:	3a 3a                	cmp    (%edx),%bh
  9b:	2e 3a 3a             	cmp    %cs:(%edx),%bh
  9e:	3c 64                	cmp    $0x64,%al
  a0:	64 64 3a 2d 3a 3a 3a 	fs cmp %fs:0x2e3a3a3a,%ch
  a7:	2e 
  a8:	3a 3a                	cmp    (%edx),%bh
  aa:	3c 1e                	cmp    $0x1e,%al
  ac:	1e                   	push   %ds
  ad:	03 17                	add    (%edi),%edx
  af:	02 62 01             	add    0x1(%edx),%ah
  b2:	1f                   	pop    %ds
  b3:	2c 2c                	sub    $0x2c,%al
  b5:	1e                   	push   %ds
  b6:	2c 2c                	sub    $0x2c,%al
  b8:	1e                   	push   %ds
  b9:	04 02                	add    $0x2,%al
  bb:	03 ba 7f 02 35 01    	add    0x135027f(%edx),%edi
  c1:	03 0a                	add    (%edx),%ecx
  c3:	2b 3a                	sub    (%edx),%edi
  c5:	3a 3c 1e             	cmp    (%esi,%ebx,1),%bh
  c8:	3c 4a                	cmp    $0x4a,%al
  ca:	56                   	push   %esi
  cb:	3a 2c 3b             	cmp    (%ebx,%edi,1),%ch
  ce:	2c 2e                	sub    $0x2e,%al
  d0:	59                   	pop    %ecx
  d1:	48                   	dec    %eax
  d2:	2c 2c                	sub    $0x2c,%al
  d4:	2c 2c                	sub    $0x2c,%al
  d6:	2c 58                	sub    $0x58,%al
  d8:	56                   	push   %esi
  d9:	20 03                	and    %al,(%ebx)
  db:	10 55 1e             	adc    %dl,0x1e(%ebp)
  de:	58                   	pop    %eax
  df:	75 48                	jne    129 <BIOS_A20_ERROR_MSG_LEN+0xdd>
  e1:	2c 2e                	sub    $0x2e,%al
  e3:	3a 2c 3a             	cmp    (%edx,%edi,1),%ch
  e6:	76 2c                	jbe    114 <BIOS_A20_ERROR_MSG_LEN+0xc8>
  e8:	2c 2e                	sub    $0x2e,%al
  ea:	58                   	pop    %eax
  eb:	4a                   	dec    %edx
  ec:	3a 1f                	cmp    (%edi),%bl
  ee:	20 2c 03             	and    %ch,(%ebx,%eax,1)
  f1:	14 02                	adc    $0x2,%al
  f3:	52                   	push   %edx
  f4:	01 2c 2c             	add    %ebp,(%esp,%ebp,1)
  f7:	2c 2c                	sub    $0x2c,%al
  f9:	23 2c 2c             	and    (%esp,%ebp,1),%ebp
  fc:	2c 2c                	sub    $0x2c,%al
  fe:	24 2c                	and    $0x2c,%al
 100:	2c 2c                	sub    $0x2c,%al
 102:	2c 23                	sub    $0x23,%al
 104:	2c 2c                	sub    $0x2c,%al
 106:	2c 2c                	sub    $0x2c,%al
 108:	04 03                	add    $0x3,%al
 10a:	03 e0                	add    %eax,%esp
 10c:	7e 1d                	jle    12b <BIOS_A20_ERROR_MSG_LEN+0xdf>
 10e:	1f                   	pop    %ds
 10f:	3a 3a                	cmp    (%edx),%bh
 111:	4a                   	dec    %edx
 112:	3a 2c 2c             	cmp    (%esp,%ebp,1),%ch
 115:	2c 2d                	sub    $0x2d,%al
 117:	3a 2c 2c             	cmp    (%esp,%ebp,1),%ch
 11a:	2c 2c                	sub    $0x2c,%al
 11c:	3a 2c 2d 3a 2c 2c 2c 	cmp    0x2c2c2c3a(,%ebp,1),%ch
 123:	3a 2e                	cmp    (%esi),%ch
 125:	3a 3a                	cmp    (%edx),%bh
 127:	3d 3a 2c 2d 3a       	cmp    $0x3a2d2c3a,%eax
 12c:	2c 2d                	sub    $0x2d,%al
 12e:	3a 2c 1f             	cmp    (%edi,%ebx,1),%ch
 131:	3a 2c 2d 3a 1e 2c 2d 	cmp    0x2d2c1e3a(,%ebp,1),%ch
 138:	3a 2c 2d 3c 3a 3a 2e 	cmp    0x2e3a3a3c(,%ebp,1),%ch
 13f:	3a 3a                	cmp    (%edx),%bh
 141:	3c 2c                	cmp    $0x2c,%al
 143:	2c 2c                	sub    $0x2c,%al
 145:	2c 2c                	sub    $0x2c,%al
 147:	2f                   	das
 148:	3a 3a                	cmp    (%edx),%bh
 14a:	2d 3c 1e 03 0e       	sub    $0xe031e3c,%eax
 14f:	02 99 01 01 1e 1e    	add    0x1e1e0101(%ecx),%bl
 155:	1e                   	push   %ds
 156:	1e                   	push   %ds
 157:	21 2c 2c             	and    %ebp,(%esp,%ebp,1)
 15a:	3b 2c 2c             	cmp    (%esp,%ebp,1),%ebp
 15d:	3c 3a                	cmp    $0x3a,%al
 15f:	1e                   	push   %ds
 160:	2c 1f                	sub    $0x1f,%al
 162:	48                   	dec    %eax
 163:	3a 4a 1e             	cmp    0x1e(%edx),%cl
 166:	2c 1e                	sub    $0x1e,%al
 168:	3b 3a                	cmp    (%edx),%edi
 16a:	2c 3c                	sub    $0x3c,%al
 16c:	1e                   	push   %ds
 16d:	1e                   	push   %ds
 16e:	1e                   	push   %ds
 16f:	1e                   	push   %ds
 170:	1f                   	pop    %ds
 171:	21 2c 2c             	and    %ebp,(%esp,%ebp,1)
 174:	2c 21                	sub    $0x21,%al
 176:	2c 2c                	sub    $0x2c,%al
 178:	2c 02                	sub    $0x2,%al
 17a:	09 00                	or     %eax,(%eax)
 17c:	01 01                	add    %eax,(%ecx)
 17e:	5d                   	pop    %ebp
 17f:	00 00                	add    %al,(%eax)
 181:	00 05 00 04 00 37    	add    %al,0x37000400
 187:	00 00                	add    %al,(%eax)
 189:	00 01                	add    %al,(%ecx)
 18b:	01 01                	add    %eax,(%ecx)
 18d:	fb                   	sti
 18e:	0e                   	push   %cs
 18f:	0d 00 01 01 01       	or     $0x1010100,%eax
 194:	01 00                	add    %eax,(%eax)
 196:	00 00                	add    %al,(%eax)
 198:	01 00                	add    %eax,(%eax)
 19a:	00 01                	add    %al,(%ecx)
 19c:	01 01                	add    %eax,(%ecx)
 19e:	1f                   	pop    %ds
 19f:	03 00                	add    (%eax),%eax
 1a1:	00 00                	add    %al,(%eax)
 1a3:	00 83 00 00 00 bb    	add    %al,-0x45000000(%ebx)
 1a9:	00 00                	add    %al,(%eax)
 1ab:	00 02                	add    %al,(%edx)
 1ad:	01 1f                	add    %ebx,(%edi)
 1af:	02 0f                	add    (%edi),%cl
 1b1:	03 76 00             	add    0x0(%esi),%esi
 1b4:	00 00                	add    %al,(%eax)
 1b6:	01 76 00             	add    %esi,0x0(%esi)
 1b9:	00 00                	add    %al,(%eax)
 1bb:	01 f0                	add    %esi,%eax
 1bd:	00 00                	add    %al,(%eax)
 1bf:	00 02                	add    %al,(%edx)
 1c1:	05 01 00 05 02       	add    $0x2050001,%eax
 1c6:	74 81                	je     149 <BIOS_A20_ERROR_MSG_LEN+0xfd>
 1c8:	00 00                	add    %al,(%eax)
 1ca:	03 09                	add    (%ecx),%ecx
 1cc:	01 05 11 67 05 05    	add    %eax,0x5056711
 1d2:	75 59                	jne    22d <BIOS_A20_ERROR_MSG_LEN+0x1e1>
 1d4:	d8 08                	fmuls  (%eax)
 1d6:	ca 05 01             	lret   $0x105
 1d9:	21 02                	and    %eax,(%edx)
 1db:	02 00                	add    (%eax),%al
 1dd:	01 01                	add    %eax,(%ecx)
 1df:	60                   	pusha
 1e0:	02 00                	add    (%eax),%al
 1e2:	00 05 00 04 00 46    	add    %al,0x46000400
 1e8:	00 00                	add    %al,(%eax)
 1ea:	00 01                	add    %al,(%ecx)
 1ec:	01 01                	add    %eax,(%ecx)
 1ee:	fb                   	sti
 1ef:	0e                   	push   %cs
 1f0:	0d 00 01 01 01       	or     $0x1010100,%eax
 1f5:	01 00                	add    %eax,(%eax)
 1f7:	00 00                	add    %al,(%eax)
 1f9:	01 00                	add    %eax,(%eax)
 1fb:	00 01                	add    %al,(%ecx)
 1fd:	01 01                	add    %eax,(%ecx)
 1ff:	1f                   	pop    %ds
 200:	03 31                	add    (%ecx),%esi
 202:	01 00                	add    %eax,(%eax)
 204:	00 bb 00 00 00 6c    	add    %bh,0x6c000000(%ebx)
 20a:	01 00                	add    %eax,(%eax)
 20c:	00 02                	add    %al,(%edx)
 20e:	01 1f                	add    %ebx,(%edi)
 210:	02 0f                	add    (%edi),%cl
 212:	06                   	push   %es
 213:	2b 01                	sub    (%ecx),%eax
 215:	00 00                	add    %al,(%eax)
 217:	01 2b                	add    %ebp,(%ebx)
 219:	01 00                	add    %eax,(%eax)
 21b:	00 01                	add    %al,(%ecx)
 21d:	a2 01 00 00 02       	mov    %al,0x2000001
 222:	f0 00 00             	lock add %al,(%eax)
 225:	00 01                	add    %al,(%ecx)
 227:	af                   	scas   %es:(%edi),%eax
 228:	01 00                	add    %eax,(%eax)
 22a:	00 02                	add    %al,(%edx)
 22c:	b8 01 00 00 02       	mov    $0x2000001,%eax
 231:	05 01 00 05 02       	add    $0x2050001,%eax
 236:	b5 81                	mov    $0x81,%ch
 238:	00 00                	add    %al,(%eax)
 23a:	03 18                	add    (%eax),%ebx
 23c:	01 05 0d 3d 05 01    	add    %eax,0x1053d0d
 242:	08 13                	or     %dl,(%ebx)
 244:	40                   	inc    %eax
 245:	05 0c 3d 05 01       	add    $0x1053d0c,%eax
 24a:	08 2f                	or     %ch,(%edi)
 24c:	78 05                	js     253 <BIOS_A20_ERROR_MSG_LEN+0x207>
 24e:	30 3d 05 32 82 05    	xor    %bh,0x5823205
 254:	30 3c 05 19 2e 05 01 	xor    %bh,0x1052e19(,%eax,1)
 25b:	59                   	pop    %ecx
 25c:	40                   	inc    %eax
 25d:	05 0c 3d 05 01       	add    $0x1053d0c,%eax
 262:	75 32                	jne    296 <BIOS_A20_ERROR_MSG_LEN+0x24a>
 264:	05 3f 68 05 0e       	add    $0xe05683f,%eax
 269:	f2 4c                	repnz dec %esp
 26b:	05 05 74 05 0a       	add    $0xa057405,%eax
 270:	30 05 26 58 05 2a    	xor    %al,0x2a055826
 276:	74 05                	je     27d <BIOS_A20_ERROR_MSG_LEN+0x231>
 278:	38 00                	cmp    %al,(%eax)
 27a:	02 04 01             	add    (%ecx,%eax,1),%al
 27d:	72 05                	jb     284 <BIOS_A20_ERROR_MSG_LEN+0x238>
 27f:	26 00 02             	add    %al,%es:(%edx)
 282:	04 02                	add    $0x2,%al
 284:	4a                   	dec    %edx
 285:	05 17 00 02 04       	add    $0x4020017,%eax
 28a:	02 c8                	add    %al,%cl
 28c:	05 0d 5d 05 01       	add    $0x1055d0d,%eax
 291:	08 3d 40 05 0e 77    	or     %bh,0x770e0540
 297:	05 05 74 05 3c       	add    $0x3c057405,%eax
 29c:	30 05 58 58 05 0a    	xor    %al,0xa055858
 2a2:	74 05                	je     2a9 <BIOS_A20_ERROR_MSG_LEN+0x25d>
 2a4:	29 58 05             	sub    %ebx,0x5(%eax)
 2a7:	26 9e                	es sahf
 2a9:	05 58 4a 05 39       	add    $0x39054a58,%eax
 2ae:	3c 05                	cmp    $0x5,%al
 2b0:	43                   	inc    %ebx
 2b1:	00 02                	add    %al,(%edx)
 2b3:	04 01                	add    $0x1,%al
 2b5:	3a 05 31 00 02 04    	cmp    0x4020031,%al
 2bb:	02 4a 05             	add    0x5(%edx),%cl
 2be:	22 00                	and    (%eax),%al
 2c0:	02 04 02             	add    (%edx,%eax,1),%al
 2c3:	c8 05 0c 5e          	enter  $0xc05,$0x5e
 2c7:	05 10 58 84 05       	add    $0x5845810,%eax
 2cc:	08 58 05             	or     %bl,0x5(%eax)
 2cf:	15 4c 9f 05 01       	adc    $0x1059f4c,%eax
 2d4:	a0 6a 05 08 68       	mov    0x6808056a,%al
 2d9:	05 10 68 05 14       	add    $0x14056810,%eax
 2de:	58                   	pop    %eax
 2df:	05 15 83 05 14       	add    $0x14058315,%eax
 2e4:	9f                   	lahf
 2e5:	05 19 58 05 0c       	add    $0xc055819,%eax
 2ea:	58                   	pop    %eax
 2eb:	05 0d 84 05 09       	add    $0x905840d,%eax
 2f0:	5a                   	pop    %edx
 2f1:	05 3f 5b 05 41       	add    $0x41055b3f,%eax
 2f6:	e4 05                	in     $0x5,%al
 2f8:	3f                   	aas
 2f9:	58                   	pop    %eax
 2fa:	05 0e 2e 05 06       	add    $0x6052e0e,%eax
 2ff:	4b                   	dec    %ebx
 300:	05 2a 58 05 2f       	add    $0x2f05582a,%eax
 305:	58                   	pop    %eax
 306:	05 47 82 05 3e       	add    $0x3e058247,%eax
 30b:	58                   	pop    %eax
 30c:	05 22 2e 05 4d       	add    $0x4d052e22,%eax
 311:	58                   	pop    %eax
 312:	05 0c 77 05 10       	add    $0x1005770c,%eax
 317:	58                   	pop    %eax
 318:	83 05 15 58 05 08 58 	addl   $0x58,0x8055815
 31f:	05 15 4c 05 10       	add    $0x10054c15,%eax
 324:	9f                   	lahf
 325:	05 14 58 83 05       	add    $0x5835814,%eax
 32a:	19 58 05             	sbb    %ebx,0x5(%eax)
 32d:	0c 58                	or     $0x58,%al
 32f:	05 0d 4c 05 09       	add    $0x9054c0d,%eax
 334:	03 72 74             	add    0x74(%edx),%esi
 337:	05 01 03 11 20       	add    $0x20110301,%eax
 33c:	32 05 0c 67 05 0b    	xor    0xb05670c,%al
 342:	75 05                	jne    349 <BIOS_A20_ERROR_MSG_LEN+0x2fd>
 344:	16                   	push   %ss
 345:	30 05 09 82 05 0a    	xor    %al,0xa058209
 34b:	e5 05                	in     $0x5,%eax
 34d:	0d 00 02 04 01       	or     $0x1040200,%eax
 352:	47                   	inc    %edi
 353:	05 0c 00 02 04       	add    $0x402000c,%eax
 358:	01 ac 05 01 4f 4e 05 	add    %ebp,0x54e4f01(%ebp,%eax,1)
 35f:	08 67 05             	or     %ah,0x5(%edi)
 362:	09 68 9f             	or     %ebp,-0x61(%eax)
 365:	05 08 5b 05 09       	add    $0x9055b08,%eax
 36a:	68 9f 5e 05 0b       	push   $0xb055e9f
 36f:	75 05                	jne    376 <BIOS_A20_ERROR_MSG_LEN+0x32a>
 371:	0d 30 05 0f 02       	or     $0x20f0530,%eax
 376:	26 13 05 24 08 9f 05 	adc    %es:0x59f0824,%eax
 37d:	1c 82                	sbb    $0x82,%al
 37f:	05 13 9f 05 17       	add    $0x17059f13,%eax
 384:	00 02                	add    %al,(%edx)
 386:	04 01                	add    $0x1,%al
 388:	45                   	inc    %ebp
 389:	00 02                	add    %al,(%edx)
 38b:	04 02                	add    $0x2,%al
 38d:	06                   	push   %es
 38e:	66 05 0e 06          	add    $0x60e,%ax
 392:	03 09                	add    (%ecx),%ecx
 394:	66 05 05 90          	add    $0x9005,%ax
 398:	05 1b 30 05 09       	add    $0x905301b,%eax
 39d:	ac                   	lods   %ds:(%esi),%al
 39e:	05 2b 00 02 04       	add    $0x402002b,%eax
 3a3:	01 b8 05 24 00 02    	add    %edi,0x2002405(%eax)
 3a9:	04 02                	add    $0x2,%al
 3ab:	4a                   	dec    %edx
 3ac:	05 01 6a 35 05       	add    $0x5356a01,%eax
 3b1:	05 67 05 11 c9       	add    $0xc9110567,%eax
 3b6:	05 05 4a 05 12       	add    $0x12054a05,%eax
 3bb:	30 05 14 67 05 0f    	xor    %al,0xf056714
 3c1:	74 59                	je     41c <BIOS_A20_ERROR_MSG_LEN+0x3d0>
 3c3:	05 09 4b 05 21       	add    $0x21054b09,%eax
 3c8:	00 02                	add    %al,(%edx)
 3ca:	04 01                	add    $0x1,%al
 3cc:	08 61 05             	or     %ah,0x5(%ecx)
 3cf:	1a 00                	sbb    (%eax),%al
 3d1:	02 04 02             	add    (%edx,%eax,1),%al
 3d4:	9e                   	sahf
 3d5:	05 01 6d 4d 05       	add    $0x54d6d01,%eax
 3da:	05 68 05 0c 68       	add    $0x680c0568,%eax
 3df:	05 0b 75 05 14       	add    $0x1405750b,%eax
 3e4:	5a                   	pop    %edx
 3e5:	05 09 d6 05 12       	add    $0x1205d609,%eax
 3ea:	93                   	xchg   %eax,%ebx
 3eb:	05 1c 4b 05 11       	add    $0x11054b1c,%eax
 3f0:	d6                   	salc
 3f1:	03 13                	add    (%ebx),%edx
 3f3:	02 26                	add    (%esi),%ah
 3f5:	01 05 2f 03 70 58    	add    %eax,0x5870032f
 3fb:	05 1e 00 02 04       	add    $0x402001e,%eax
 400:	01 ac 05 19 3d c9 05 	add    %ebp,0x5c93d19(%ebp,%eax,1)
 407:	1d 30 05 19 d7       	sbb    $0xd7190530,%eax
 40c:	ad                   	lods   %ds:(%esi),%eax
 40d:	05 1f 30 05 19       	add    $0x1905301f,%eax
 412:	d7                   	xlat   %ds:(%ebx)
 413:	ad                   	lods   %ds:(%esi),%eax
 414:	05 1f 30 05 19       	add    $0x1905301f,%eax
 419:	d7                   	xlat   %ds:(%ebx)
 41a:	ad                   	lods   %ds:(%esi),%eax
 41b:	05 11 22 05 20       	add    $0x20052211,%eax
 420:	31 05 11 82 e5 2a    	xor    %eax,0x2ae58211
 426:	05 0a 26 05 0f       	add    $0xf05260a,%eax
 42b:	00 02                	add    %al,(%edx)
 42d:	04 01                	add    $0x1,%al
 42f:	03 61 4a             	add    0x4a(%ecx),%esp
 432:	05 0c 00 02 04       	add    $0x402000c,%eax
 437:	01 ac 05 01 03 23 82 	add    %ebp,-0x7ddcfcff(%ebp,%eax,1)
 43e:	02 04 00             	add    (%eax,%eax,1),%al
 441:	01 01                	add    %eax,(%ecx)

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	22 00                	and    (%eax),%al
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	00 00                	add    %al,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	04 01                	add    $0x1,%al
   c:	00 00                	add    %al,(%eax)
   e:	00 00                	add    %al,(%eax)
  10:	00 7e 00             	add    %bh,0x0(%esi)
  13:	00 74 81 00          	add    %dh,0x0(%ecx,%eax,4)
  17:	00 00                	add    %al,(%eax)
  19:	00 00                	add    %al,(%eax)
  1b:	00 47 00             	add    %al,0x0(%edi)
  1e:	00 00                	add    %al,(%eax)
  20:	85 00                	test   %eax,(%eax)
  22:	00 00                	add    %al,(%eax)
  24:	01 80 cb 00 00 00    	add    %eax,0xcb(%eax)
  2a:	05 00 01 04 14       	add    $0x14040100,%eax
  2f:	00 00                	add    %al,(%eax)
  31:	00 04 a1             	add    %al,(%ecx,%eiz,4)
  34:	00 00                	add    %al,(%eax)
  36:	00 0c 3e             	add    %cl,(%esi,%edi,1)
  39:	00 00                	add    %al,(%eax)
  3b:	00 00                	add    %al,(%eax)
  3d:	00 00                	add    %al,(%eax)
  3f:	00 74 81 00          	add    %dh,0x0(%ecx,%eax,4)
  43:	00 41 00             	add    %al,0x0(%ecx)
  46:	00 00                	add    %al,(%eax)
  48:	7e 01                	jle    4b <PM_SUCCESS_MSG_LEN+0x15>
  4a:	00 00                	add    %al,(%eax)
  4c:	01 04 05 5b 01 00 00 	add    %eax,0x15b(,%eax,1)
  53:	01 04 07             	add    %eax,(%edi,%eax,1)
  56:	39 01                	cmp    %eax,(%ecx)
  58:	00 00                	add    %al,(%eax)
  5a:	05 04 05 69 6e       	add    $0x6e690504,%eax
  5f:	74 00                	je     61 <BIOS_A20_ERROR_MSG_LEN+0x15>
  61:	01 01                	add    %eax,(%ecx)
  63:	06                   	push   %es
  64:	04 01                	add    $0x1,%al
  66:	00 00                	add    %al,(%eax)
  68:	01 02                	add    %eax,(%edx)
  6a:	05 64 01 00 00       	add    $0x164,%eax
  6f:	01 08                	add    %ecx,(%eax)
  71:	05 56 01 00 00       	add    $0x156,%eax
  76:	01 01                	add    %eax,(%ecx)
  78:	08 02                	or     %al,(%edx)
  7a:	01 00                	add    %eax,(%eax)
  7c:	00 01                	add    %al,(%ecx)
  7e:	02 07                	add    (%edi),%al
  80:	10 01                	adc    %al,(%ecx)
  82:	00 00                	add    %al,(%eax)
  84:	01 08                	add    %ecx,(%eax)
  86:	07                   	pop    %es
  87:	34 01                	xor    $0x1,%al
  89:	00 00                	add    %al,(%eax)
  8b:	01 04 07             	add    %eax,(%edi,%eax,1)
  8e:	3e 01 00             	add    %eax,%ds:(%eax)
  91:	00 02                	add    %al,(%edx)
  93:	4b                   	dec    %ebx
  94:	01 00                	add    %eax,(%eax)
  96:	00 49 7d             	add    %cl,0x7d(%ecx)
  99:	00 00                	add    %al,(%eax)
  9b:	00 03                	add    %al,(%ebx)
  9d:	83 00 00             	addl   $0x0,(%eax)
  a0:	00 06                	add    %al,(%esi)
  a2:	00 07                	add    %al,(%edi)
  a4:	04 8f                	add    $0x8f,%al
  a6:	00 00                	add    %al,(%eax)
  a8:	00 08                	add    %cl,(%eax)
  aa:	7d 00                	jge    ac <BIOS_A20_ERROR_MSG_LEN+0x60>
  ac:	00 00                	add    %al,(%eax)
  ae:	01 01                	add    %eax,(%ecx)
  b0:	06                   	push   %es
  b1:	0b 01                	or     (%ecx),%eax
  b3:	00 00                	add    %al,(%eax)
  b5:	09 88 00 00 00 02    	or     %ecx,0x2000000(%eax)
  bb:	2a 01                	sub    (%ecx),%al
  bd:	00 00                	add    %al,(%eax)
  bf:	40                   	inc    %eax
  c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  c1:	00 00                	add    %al,(%eax)
  c3:	00 03                	add    %al,(%ebx)
  c5:	7d 00                	jge    c7 <BIOS_A20_ERROR_MSG_LEN+0x7b>
  c7:	00 00                	add    %al,(%eax)
  c9:	00 0a                	add    %cl,(%edx)
  cb:	6e                   	outsb  %ds:(%esi),(%dx)
  cc:	01 00                	add    %eax,(%eax)
  ce:	00 02                	add    %al,(%edx)
  d0:	37                   	aaa
  d1:	06                   	push   %es
  d2:	0b 91 00 00 00 01    	or     0x1000000(%ecx),%edx
  d8:	09 06                	or     %eax,(%esi)
  da:	74 81                	je     5d <BIOS_A20_ERROR_MSG_LEN+0x11>
  dc:	00 00                	add    %al,(%eax)
  de:	41                   	inc    %ecx
  df:	00 00                	add    %al,(%eax)
  e1:	00 01                	add    %al,(%ecx)
  e3:	9c                   	pushf
  e4:	0c 23                	or     $0x23,%al
  e6:	01 00                	add    %eax,(%eax)
  e8:	00 01                	add    %al,(%ecx)
  ea:	0b 11                	or     (%ecx),%edx
  ec:	7d 00                	jge    ee <BIOS_A20_ERROR_MSG_LEN+0xa2>
  ee:	00 00                	add    %al,(%eax)
  f0:	02 91 6c 00 00 a3    	add    -0x5cffff94(%ecx),%dl
  f6:	04 00                	add    $0x0,%al
  f8:	00 05 00 01 04 b5    	add    %al,0xb5040100
  fe:	00 00                	add    %al,(%eax)
 100:	00 11                	add    %dl,(%ecx)
 102:	a1 00 00 00 0c       	mov    0xc000000,%eax
 107:	f6 00 00             	testb  $0x0,(%eax)
 10a:	00 31                	add    %dh,(%ecx)
 10c:	01 00                	add    %eax,(%eax)
 10e:	00 b5 81 00 00 6f    	add    %dh,0x6f000081(%ebp)
 114:	04 00                	add    $0x0,%al
 116:	00 df                	add    %bl,%bh
 118:	01 00                	add    %eax,(%eax)
 11a:	00 04 f2             	add    %al,(%edx,%esi,8)
 11d:	01 00                	add    %eax,(%eax)
 11f:	00 02                	add    %al,(%edx)
 121:	22 17                	and    (%edi),%dl
 123:	32 00                	xor    (%eax),%al
 125:	00 00                	add    %al,(%eax)
 127:	03 01                	add    (%ecx),%eax
 129:	06                   	push   %es
 12a:	04 01                	add    $0x1,%al
 12c:	00 00                	add    %al,(%eax)
 12e:	03 02                	add    (%edx),%eax
 130:	05 64 01 00 00       	add    $0x164,%eax
 135:	03 04 05 5b 01 00 00 	add    0x15b(,%eax,1),%eax
 13c:	03 08                	add    (%eax),%ecx
 13e:	05 56 01 00 00       	add    $0x156,%eax
 143:	04 f1                	add    $0xf1,%al
 145:	01 00                	add    %eax,(%eax)
 147:	00 02                	add    %al,(%edx)
 149:	2e 18 5a 00          	sbb    %bl,%cs:0x0(%edx)
 14d:	00 00                	add    %al,(%eax)
 14f:	03 01                	add    (%ecx),%eax
 151:	08 02                	or     %al,(%edx)
 153:	01 00                	add    %eax,(%eax)
 155:	00 04 67             	add    %al,(%edi,%eiz,2)
 158:	02 00                	add    (%eax),%al
 15a:	00 02                	add    %al,(%edx)
 15c:	31 19                	xor    %ebx,(%ecx)
 15e:	6d                   	insl   (%dx),%es:(%edi)
 15f:	00 00                	add    %al,(%eax)
 161:	00 03                	add    %al,(%ebx)
 163:	02 07                	add    (%edi),%al
 165:	10 01                	adc    %al,(%ecx)
 167:	00 00                	add    %al,(%eax)
 169:	04 58                	add    $0x58,%al
 16b:	02 00                	add    (%eax),%al
 16d:	00 02                	add    %al,(%edx)
 16f:	34 19                	xor    $0x19,%al
 171:	80 00 00             	addb   $0x0,(%eax)
 174:	00 03                	add    %al,(%ebx)
 176:	04 07                	add    $0x7,%al
 178:	39 01                	cmp    %eax,(%ecx)
 17a:	00 00                	add    %al,(%eax)
 17c:	03 08                	add    (%eax),%ecx
 17e:	07                   	pop    %es
 17f:	34 01                	xor    $0x1,%al
 181:	00 00                	add    %al,(%eax)
 183:	12 04 05 69 6e 74 00 	adc    0x746e69(,%eax,1),%al
 18a:	09 8e 00 00 00 03    	or     %ecx,0x3000000(%esi)
 190:	04 07                	add    $0x7,%al
 192:	3e 01 00             	add    %eax,%ds:(%eax)
 195:	00 13                	add    %dl,(%ebx)
 197:	b3 01                	mov    $0x1,%bl
 199:	00 00                	add    %al,(%eax)
 19b:	08 03                	or     %al,(%ebx)
 19d:	0d 10 c5 00 00       	or     $0xc510,%eax
 1a2:	00 0b                	add    %cl,(%ebx)
 1a4:	72 6f                	jb     215 <BIOS_A20_ERROR_MSG_LEN+0x1c9>
 1a6:	77 00                	ja     1a8 <BIOS_A20_ERROR_MSG_LEN+0x15c>
 1a8:	0f 8e 00 00 00 00    	jle    1ae <BIOS_A20_ERROR_MSG_LEN+0x162>
 1ae:	0b 63 6f             	or     0x6f(%ebx),%esp
 1b1:	6c                   	insb   (%dx),%es:(%edi)
 1b2:	00 10                	add    %dl,(%eax)
 1b4:	8e 00                	mov    (%eax),%es
 1b6:	00 00                	add    %al,(%eax)
 1b8:	04 00                	add    $0x0,%al
 1ba:	04 b3                	add    $0xb3,%al
 1bc:	01 00                	add    %eax,(%eax)
 1be:	00 03                	add    %al,(%ebx)
 1c0:	11 03                	adc    %eax,(%ebx)
 1c2:	a1 00 00 00 14       	mov    0x14000000,%eax
 1c7:	f4                   	hlt
 1c8:	02 00                	add    (%eax),%al
 1ca:	00 07                	add    %al,(%edi)
 1cc:	04 9a                	add    $0x9a,%al
 1ce:	00 00                	add    %al,(%eax)
 1d0:	00 03                	add    %al,(%ebx)
 1d2:	16                   	push   %ss
 1d3:	0e                   	push   %cs
 1d4:	44                   	inc    %esp
 1d5:	01 00                	add    %eax,(%eax)
 1d7:	00 02                	add    %al,(%edx)
 1d9:	61                   	popa
 1da:	02 00                	add    (%eax),%al
 1dc:	00 00                	add    %al,(%eax)
 1de:	02 15 02 00 00 01    	add    0x1000002,%dl
 1e4:	02 77 02             	add    0x2(%edi),%dh
 1e7:	00 00                	add    %al,(%eax)
 1e9:	02 02                	add    (%edx),%al
 1eb:	e3 02                	jecxz  1ef <BIOS_A20_ERROR_MSG_LEN+0x1a3>
 1ed:	00 00                	add    %al,(%eax)
 1ef:	03 15 52 45 44 00    	add    0x444552,%edx
 1f5:	04 02                	add    $0x2,%al
 1f7:	19 03                	sbb    %eax,(%ebx)
 1f9:	00 00                	add    %al,(%eax)
 1fb:	05 02 02 03 00       	add    $0x30202,%eax
 200:	00 06                	add    %al,(%esi)
 202:	02 ad 01 00 00 07    	add    0x7000001(%ebp),%ch
 208:	02 09                	add    (%ecx),%cl
 20a:	02 00                	add    (%eax),%al
 20c:	00 08                	add    %cl,(%eax)
 20e:	02 0e                	add    (%esi),%cl
 210:	02 00                	add    (%eax),%al
 212:	00 09                	add    %cl,(%ecx)
 214:	02 70 02             	add    0x2(%eax),%dh
 217:	00 00                	add    %al,(%eax)
 219:	0a 02                	or     (%edx),%al
 21b:	dc 02                	faddl  (%edx)
 21d:	00 00                	add    %al,(%eax)
 21f:	0b 02                	or     (%edx),%eax
 221:	94                   	xchg   %eax,%esp
 222:	02 00                	add    (%eax),%al
 224:	00 0c 02             	add    %cl,(%edx,%eax,1)
 227:	12 03                	adc    (%ebx),%al
 229:	00 00                	add    %al,(%eax)
 22b:	0d 02 02 02 00       	or     $0x20202,%eax
 230:	00 0e                	add    %cl,(%esi)
 232:	02 a6 01 00 00 0f    	add    0xf000001(%esi),%ah
 238:	00 04 f4             	add    %al,(%esp,%esi,8)
 23b:	02 00                	add    (%eax),%al
 23d:	00 03                	add    %al,(%ebx)
 23f:	28 03                	sub    %al,(%ebx)
 241:	d1 00                	roll   $1,(%eax)
 243:	00 00                	add    %al,(%eax)
 245:	04 a7                	add    $0xa7,%al
 247:	02 00                	add    (%eax),%al
 249:	00 04 e5 17 80 00 00 	add    %al,0x8017(,%eiz,8)
 250:	00 04 21             	add    %al,(%ecx,%eiz,1)
 253:	03 00                	add    (%eax),%eax
 255:	00 05 28 1b 68 01    	add    %al,0x1681b28
 25b:	00 00                	add    %al,(%eax)
 25d:	16                   	push   %ss
 25e:	04 ca                	add    $0xca,%al
 260:	02 00                	add    (%eax),%al
 262:	00 72 01             	add    %dh,0x1(%edx)
 265:	00 00                	add    %al,(%eax)
 267:	03 01                	add    (%ecx),%eax
 269:	06                   	push   %es
 26a:	0b 01                	or     (%ecx),%eax
 26c:	00 00                	add    %al,(%eax)
 26e:	09 72 01             	or     %esi,0x1(%edx)
 271:	00 00                	add    %al,(%eax)
 273:	04 28                	add    $0x28,%al
 275:	03 00                	add    (%eax),%eax
 277:	00 05 68 18 5c 01    	add    %al,0x15c1868
 27d:	00 00                	add    %al,(%eax)
 27f:	01 bd 02 00 00 0a    	add    %edi,0xa000002(%ebp)
 285:	12 95 00 00 00 05    	adc    0x5000000(%ebp),%dl
 28b:	03 88 86 00 00 01    	add    0x1000086(%eax),%ecx
 291:	be 01 00 00 0b       	mov    $0xb000001,%esi
 296:	12 95 00 00 00 05    	adc    0x5000000(%ebp),%dl
 29c:	03 8c 86 00 00 01 89 	add    -0x76ff0000(%esi,%eax,4),%ecx
 2a3:	01 00                	add    %eax,(%eax)
 2a5:	00 0f                	add    %cl,(%edi)
 2a7:	14 bf                	adc    $0xbf,%al
 2a9:	01 00                	add    %eax,(%eax)
 2ab:	00 05 03 90 86 00    	add    %al,0x869003
 2b1:	00 17                	add    %dl,(%edi)
 2b3:	04 09                	add    $0x9,%al
 2b5:	bd 01 00 00 01       	mov    $0x1000001,%ebp
 2ba:	e9 01 00 00 12       	jmp    120002c0 <_cursor+0x11ff7c18>
 2bf:	13 c5                	adc    %ebp,%eax
 2c1:	00 00                	add    %al,(%eax)
 2c3:	00 05 03 a8 86 00    	add    %al,0x86a803
 2c9:	00 01                	add    %al,(%ecx)
 2cb:	33 02                	xor    (%edx),%eax
 2cd:	00 00                	add    %al,(%eax)
 2cf:	15 10 4e 00 00       	adc    $0x4e10,%eax
 2d4:	00 05 03 a7 86 00    	add    %al,0x86a703
 2da:	00 0c 79             	add    %cl,(%ecx,%edi,2)
 2dd:	01 00                	add    %eax,(%eax)
 2df:	00 f6                	add    %dh,%dh
 2e1:	01 00                	add    %eax,(%eax)
 2e3:	00 0d 80 00 00 00    	add    %cl,0x80
 2e9:	0f 00 09             	str    (%ecx)
 2ec:	e6 01                	out    %al,$0x1
 2ee:	00 00                	add    %al,(%eax)
 2f0:	01 08                	add    %ecx,(%eax)
 2f2:	03 00                	add    (%eax),%eax
 2f4:	00 9d 13 f6 01 00    	add    %bl,0x1f613(%ebp)
 2fa:	00 05 03 94 86 00    	add    %al,0x869403
 300:	00 08                	add    %cl,(%eax)
 302:	4b                   	dec    %ebx
 303:	01 00                	add    %eax,(%eax)
 305:	00 ad 14 85 00 00    	add    %ch,0x8514(%ebp)
 30b:	10 01                	adc    %al,(%ecx)
 30d:	00 00                	add    %al,(%eax)
 30f:	01 9c 8b 02 00 00 06 	add    %ebx,0x6000002(%ebx,%ecx,4)
 316:	66 6d                	insw   (%dx),%es:(%edi)
 318:	74 00                	je     31a <BIOS_A20_ERROR_MSG_LEN+0x2ce>
 31a:	ad                   	lods   %ds:(%esi),%eax
 31b:	26 90                	es nop
 31d:	02 00                	add    (%eax),%al
 31f:	00 02                	add    %al,(%edx)
 321:	91                   	xchg   %eax,%ecx
 322:	00 18                	add    %bl,(%eax)
 324:	05 61 70 00 af       	add    $0xaf007061,%eax
 329:	0d 7e 01 00 00       	or     $0x17e,%eax
 32e:	02 91 60 05 69 00    	add    0x690560(%ecx),%dl
 334:	b2 0c                	mov    $0xc,%dl
 336:	50                   	push   %eax
 337:	01 00                	add    %eax,(%eax)
 339:	00 02                	add    %al,(%edx)
 33b:	91                   	xchg   %eax,%ecx
 33c:	74 07                	je     345 <BIOS_A20_ERROR_MSG_LEN+0x2f9>
 33e:	80 85 00 00 6d 00 00 	addb   $0x0,0x6d0000(%ebp)
 345:	00 01                	add    %al,(%ecx)
 347:	f9                   	stc
 348:	01 00                	add    %eax,(%eax)
 34a:	00 bc 1e 72 01 00 00 	add    %bh,0x172(%esi,%ebx,1)
 351:	02 91 67 01 9f 02    	add    0x29f0167(%ecx),%dl
 357:	00 00                	add    %al,(%eax)
 359:	c0 1d 8e 00 00 00 02 	rcrb   $0x2,0x8e
 360:	91                   	xchg   %eax,%ecx
 361:	68 01 ae 02 00       	push   $0x2ae01
 366:	00 c4                	add    %al,%ah
 368:	1f                   	pop    %ds
 369:	bd 01 00 00 02       	mov    $0x2000001,%ebp
 36e:	91                   	xchg   %eax,%ecx
 36f:	6c                   	insb   (%dx),%es:(%edi)
 370:	01 1a                	add    %ebx,(%edx)
 372:	02 00                	add    (%eax),%al
 374:	00 c8                	add    %cl,%al
 376:	1f                   	pop    %ds
 377:	95                   	xchg   %eax,%ebp
 378:	02 00                	add    (%eax),%al
 37a:	00 02                	add    %al,(%edx)
 37c:	91                   	xchg   %eax,%ecx
 37d:	70 00                	jo     37f <BIOS_A20_ERROR_MSG_LEN+0x333>
 37f:	00 0e                	add    %cl,(%esi)
 381:	79 01                	jns    384 <BIOS_A20_ERROR_MSG_LEN+0x338>
 383:	00 00                	add    %al,(%eax)
 385:	19 8b 02 00 00 0e    	sbb    %ecx,0xe000002(%ebx)
 38b:	72 01                	jb     38e <BIOS_A20_ERROR_MSG_LEN+0x342>
 38d:	00 00                	add    %al,(%eax)
 38f:	08 47 02             	or     %al,0x2(%edi)
 392:	00 00                	add    %al,(%eax)
 394:	a1 ba 84 00 00       	mov    0x84ba,%eax
 399:	5a                   	pop    %edx
 39a:	00 00                	add    %al,(%eax)
 39c:	00 01                	add    %al,(%ecx)
 39e:	9c                   	pushf
 39f:	eb 02                	jmp    3a3 <BIOS_A20_ERROR_MSG_LEN+0x357>
 3a1:	00 00                	add    %al,(%eax)
 3a3:	06                   	push   %es
 3a4:	70 74                	jo     41a <BIOS_A20_ERROR_MSG_LEN+0x3ce>
 3a6:	72 00                	jb     3a8 <BIOS_A20_ERROR_MSG_LEN+0x35c>
 3a8:	a1 1d bd 01 00       	mov    0x1bd1d,%eax
 3ad:	00 02                	add    %al,(%edx)
 3af:	91                   	xchg   %eax,%ecx
 3b0:	00 07                	add    %al,(%edi)
 3b2:	cd 84                	int    $0x84
 3b4:	00 00                	add    %al,(%eax)
 3b6:	43                   	inc    %ebx
 3b7:	00 00                	add    %al,(%eax)
 3b9:	00 05 69 00 a4 11    	add    %al,0x11a40069
 3bf:	26 00 00             	add    %al,%es:(%eax)
 3c2:	00 02                	add    %al,(%edx)
 3c4:	91                   	xchg   %eax,%ecx
 3c5:	77 07                	ja     3ce <BIOS_A20_ERROR_MSG_LEN+0x382>
 3c7:	d3 84 00 00 2d 00 00 	roll   %cl,0x2d00(%eax,%eax,1)
 3ce:	00 01                	add    %al,(%ecx)
 3d0:	e3 01                	jecxz  3d3 <BIOS_A20_ERROR_MSG_LEN+0x387>
 3d2:	00 00                	add    %al,(%eax)
 3d4:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
 3d5:	12 74 00 00          	adc    0x0(%eax,%eax,1),%dh
 3d9:	00 02                	add    %al,(%edx)
 3db:	91                   	xchg   %eax,%ecx
 3dc:	70 00                	jo     3de <BIOS_A20_ERROR_MSG_LEN+0x392>
 3de:	00 00                	add    %al,(%eax)
 3e0:	08 99 01 00 00 7c    	or     %bl,0x7c000001(%ecx)
 3e6:	f0 83 00 00          	lock addl $0x0,(%eax)
 3ea:	ca 00 00             	lret   $0x0
 3ed:	00 01                	add    %al,(%ecx)
 3ef:	9c                   	pushf
 3f0:	5c                   	pop    %esp
 3f1:	03 00                	add    (%eax),%eax
 3f3:	00 0f                	add    %cl,(%edi)
 3f5:	e3 01                	jecxz  3f8 <BIOS_A20_ERROR_MSG_LEN+0x3ac>
 3f7:	00 00                	add    %al,(%eax)
 3f9:	7c 17                	jl     412 <BIOS_A20_ERROR_MSG_LEN+0x3c6>
 3fb:	8e 00                	mov    (%eax),%es
 3fd:	00 00                	add    %al,(%eax)
 3ff:	02 91 00 01 b6 02    	add    0x2b60100(%ecx),%dl
 405:	00 00                	add    %al,(%eax)
 407:	8b 0a                	mov    (%edx),%ecx
 409:	5c                   	pop    %esp
 40a:	03 00                	add    (%eax),%eax
 40c:	00 02                	add    %al,(%edx)
 40e:	91                   	xchg   %eax,%ecx
 40f:	62 01                	bound  %eax,(%ecx)
 411:	7e 01                	jle    414 <BIOS_A20_ERROR_MSG_LEN+0x3c8>
 413:	00 00                	add    %al,(%eax)
 415:	8d 09                	lea    (%ecx),%ecx
 417:	8e 00                	mov    (%eax),%es
 419:	00 00                	add    %al,(%eax)
 41b:	02 91 74 1a 29 84    	add    -0x7bd6e58c(%ecx),%dl
 421:	00 00                	add    %al,(%eax)
 423:	57                   	push   %edi
 424:	00 00                	add    %al,(%eax)
 426:	00 45 03             	add    %al,0x3(%ebp)
 429:	00 00                	add    %al,(%eax)
 42b:	01 30                	add    %esi,(%eax)
 42d:	03 00                	add    (%eax),%eax
 42f:	00 90 0d 8e 00 00    	add    %dl,0x8e0d(%eax)
 435:	00 02                	add    %al,(%edx)
 437:	91                   	xchg   %eax,%ecx
 438:	6c                   	insb   (%dx),%es:(%edi)
 439:	00 07                	add    %al,(%edi)
 43b:	8c 84 00 00 2c 00 00 	mov    %es,0x2c00(%eax,%eax,1)
 442:	00 05 69 00 97 0e    	add    %al,0xe970069
 448:	8e 00                	mov    (%eax),%es
 44a:	00 00                	add    %al,(%eax)
 44c:	02 91 70 00 00 0c    	add    0xc000070(%ecx),%dl
 452:	72 01                	jb     455 <BIOS_A20_ERROR_MSG_LEN+0x409>
 454:	00 00                	add    %al,(%eax)
 456:	6c                   	insb   (%dx),%es:(%edi)
 457:	03 00                	add    (%eax),%eax
 459:	00 0d 80 00 00 00    	add    %cl,0x80
 45f:	09 00                	or     %eax,(%eax)
 461:	08 2a                	or     %ch,(%edx)
 463:	01 00                	add    %eax,(%eax)
 465:	00 71 b3             	add    %dh,-0x4d(%ecx)
 468:	83 00 00             	addl   $0x0,(%eax)
 46b:	3d 00 00 00 01       	cmp    $0x1000000,%eax
 470:	9c                   	pushf
 471:	99                   	cltd
 472:	03 00                	add    (%eax),%eax
 474:	00 06                	add    %al,(%esi)
 476:	73 00                	jae    478 <BIOS_A20_ERROR_MSG_LEN+0x42c>
 478:	71 1d                	jno    497 <BIOS_A20_ERROR_MSG_LEN+0x44b>
 47a:	8b 02                	mov    (%edx),%eax
 47c:	00 00                	add    %al,(%eax)
 47e:	02 91 00 05 69 00    	add    0x690500(%ecx),%dl
 484:	73 0c                	jae    492 <BIOS_A20_ERROR_MSG_LEN+0x446>
 486:	50                   	push   %eax
 487:	01 00                	add    %eax,(%eax)
 489:	00 02                	add    %al,(%edx)
 48b:	91                   	xchg   %eax,%ecx
 48c:	74 00                	je     48e <BIOS_A20_ERROR_MSG_LEN+0x442>
 48e:	08 e8                	or     %ch,%al
 490:	02 00                	add    (%eax),%al
 492:	00 52 eb             	add    %dl,-0x15(%edx)
 495:	82 00 00             	addb   $0x0,(%eax)
 498:	c8 00 00 00          	enter  $0x0,$0x0
 49c:	01 9c c8 03 00 00 06 	add    %ebx,0x6000003(%eax,%ecx,8)
 4a3:	63 00                	arpl   %eax,(%eax)
 4a5:	52                   	push   %edx
 4a6:	1d 79 01 00 00       	sbb    $0x179,%eax
 4ab:	02 91 00 01 44 03    	add    0x3440100(%ecx),%dl
 4b1:	00 00                	add    %al,(%eax)
 4b3:	60                   	pusha
 4b4:	0e                   	push   %cs
 4b5:	61                   	popa
 4b6:	00 00                	add    %al,(%eax)
 4b8:	00 02                	add    %al,(%edx)
 4ba:	91                   	xchg   %eax,%ecx
 4bb:	76 00                	jbe    4bd <BIOS_A20_ERROR_MSG_LEN+0x471>
 4bd:	0a 4e 03             	or     0x3(%esi),%cl
 4c0:	00 00                	add    %al,(%eax)
 4c2:	3e 70 82             	jo,pt  447 <BIOS_A20_ERROR_MSG_LEN+0x3fb>
 4c5:	00 00                	add    %al,(%eax)
 4c7:	7b 00                	jnp    4c9 <BIOS_A20_ERROR_MSG_LEN+0x47d>
 4c9:	00 00                	add    %al,(%eax)
 4cb:	01 9c f3 03 00 00 07 	add    %ebx,0x7000003(%ebx,%esi,8)
 4d2:	77 82                	ja     456 <BIOS_A20_ERROR_MSG_LEN+0x40a>
 4d4:	00 00                	add    %al,(%eax)
 4d6:	44                   	inc    %esp
 4d7:	00 00                	add    %al,(%eax)
 4d9:	00 05 69 00 42 0e    	add    %al,0xe420069
 4df:	8e 00                	mov    (%eax),%es
 4e1:	00 00                	add    %al,(%eax)
 4e3:	02 91 70 00 00 0a    	add    0xa000070(%ecx),%dl
 4e9:	6e                   	outsb  %ds:(%esi),(%dx)
 4ea:	01 00                	add    %eax,(%eax)
 4ec:	00 30                	add    %dh,(%eax)
 4ee:	0d 82 00 00 63       	or     $0x63000082,%eax
 4f3:	00 00                	add    %al,(%eax)
 4f5:	00 01                	add    %al,(%ecx)
 4f7:	9c                   	pushf
 4f8:	2c 04                	sub    $0x4,%al
 4fa:	00 00                	add    %al,(%eax)
 4fc:	01 44 03 00          	add    %eax,0x0(%ebx,%eax,1)
 500:	00 33                	add    %dh,(%ebx)
 502:	0e                   	push   %cs
 503:	61                   	popa
 504:	00 00                	add    %al,(%eax)
 506:	00 02                	add    %al,(%edx)
 508:	91                   	xchg   %eax,%ecx
 509:	72 07                	jb     512 <BIOS_A20_ERROR_MSG_LEN+0x4c6>
 50b:	27                   	daa
 50c:	82 00 00             	addb   $0x0,(%eax)
 50f:	32 00                	xor    (%eax),%al
 511:	00 00                	add    %al,(%eax)
 513:	05 69 00 35 0e       	add    $0xe350069,%eax
 518:	8e 00                	mov    (%eax),%es
 51a:	00 00                	add    %al,(%eax)
 51c:	02 91 74 00 00 10    	add    0x10000074(%ecx),%dl
 522:	cc                   	int3
 523:	01 00                	add    %eax,(%eax)
 525:	00 2a                	add    %ch,(%edx)
 527:	09 4e 00             	or     %ecx,0x0(%esi)
 52a:	00 00                	add    %al,(%eax)
 52c:	01 82 00 00 0c 00    	add    %eax,0xc0000(%edx)
 532:	00 00                	add    %al,(%eax)
 534:	01 9c 0a 7d 02 00 00 	add    %ebx,0x27d(%edx,%ecx,1)
 53b:	24 e9                	and    $0xe9,%al
 53d:	81 00 00 18 00 00    	addl   $0x1800,(%eax)
 543:	00 01                	add    %al,(%ecx)
 545:	9c                   	pushf
 546:	70 04                	jo     54c <BIOS_A20_ERROR_MSG_LEN+0x500>
 548:	00 00                	add    %al,(%eax)
 54a:	06                   	push   %es
 54b:	66 67 00 24          	data16 add %ah,(%si)
 54f:	2b 44 01 00          	sub    0x0(%ecx,%eax,1),%eax
 553:	00 02                	add    %al,(%edx)
 555:	91                   	xchg   %eax,%ecx
 556:	00 06                	add    %al,(%esi)
 558:	62 67 00             	bound  %esp,0x0(%edi)
 55b:	24 3d                	and    $0x3d,%al
 55d:	44                   	inc    %esp
 55e:	01 00                	add    %eax,(%eax)
 560:	00 02                	add    %al,(%edx)
 562:	91                   	xchg   %eax,%ecx
 563:	04 00                	add    $0x0,%al
 565:	10 25 02 00 00 1e    	adc    %ah,0x1e000002
 56b:	0c c5                	or     $0xc5,%al
 56d:	00 00                	add    %al,(%eax)
 56f:	00 cc                	add    %cl,%ah
 571:	81 00 00 1d 00 00    	addl   $0x1d00,(%eax)
 577:	00 01                	add    %al,(%ecx)
 579:	9c                   	pushf
 57a:	1b 36                	sbb    (%esi),%esi
 57c:	03 00                	add    (%eax),%eax
 57e:	00 01                	add    %al,(%ecx)
 580:	18 06                	sbb    %al,(%esi)
 582:	b5 81                	mov    $0x81,%ch
 584:	00 00                	add    %al,(%eax)
 586:	17                   	pop    %ss
 587:	00 00                	add    %al,(%eax)
 589:	00 01                	add    %al,(%ecx)
 58b:	9c                   	pushf
 58c:	0f ea 01             	pminsw (%ecx),%mm0
 58f:	00 00                	add    %al,(%eax)
 591:	18 1f                	sbb    %bl,(%edi)
 593:	c5 00                	lds    (%eax),%eax
 595:	00 00                	add    %al,(%eax)
 597:	02                   	.byte 0x2
 598:	91                   	xchg   %eax,%ecx
 599:	00 00                	add    %al,(%eax)
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	01 11                	add    %edx,(%ecx)
   2:	00 10                	add    %dl,(%eax)
   4:	06                   	push   %es
   5:	11 01                	adc    %eax,(%ecx)
   7:	12 01                	adc    (%ecx),%al
   9:	03 0e                	add    (%esi),%ecx
   b:	1b 0e                	sbb    (%esi),%ecx
   d:	25 0e 13 05 00       	and    $0x5130e,%eax
  12:	00 00                	add    %al,(%eax)
  14:	01 24 00             	add    %esp,(%eax,%eax,1)
  17:	0b 0b                	or     (%ebx),%ecx
  19:	3e 0b 03             	or     %ds:(%ebx),%eax
  1c:	0e                   	push   %cs
  1d:	00 00                	add    %al,(%eax)
  1f:	02 2e                	add    (%esi),%ch
  21:	01 3f                	add    %edi,(%edi)
  23:	19 03                	sbb    %eax,(%ebx)
  25:	0e                   	push   %cs
  26:	3a 21                	cmp    (%ecx),%ah
  28:	02 3b                	add    (%ebx),%bh
  2a:	0b 39                	or     (%ecx),%edi
  2c:	21 06                	and    %eax,(%esi)
  2e:	27                   	daa
  2f:	19 3c 19             	sbb    %edi,(%ecx,%ebx,1)
  32:	01 13                	add    %edx,(%ebx)
  34:	00 00                	add    %al,(%eax)
  36:	03 05 00 49 13 00    	add    0x134900,%eax
  3c:	00 04 11             	add    %al,(%ecx,%edx,1)
  3f:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
  45:	1f                   	pop    %ds
  46:	1b 1f                	sbb    (%edi),%ebx
  48:	11 01                	adc    %eax,(%ecx)
  4a:	12 06                	adc    (%esi),%al
  4c:	10 17                	adc    %dl,(%edi)
  4e:	00 00                	add    %al,(%eax)
  50:	05 24 00 0b 0b       	add    $0xb0b0024,%eax
  55:	3e 0b 03             	or     %ds:(%ebx),%eax
  58:	08 00                	or     %al,(%eax)
  5a:	00 06                	add    %al,(%esi)
  5c:	18 00                	sbb    %al,(%eax)
  5e:	00 00                	add    %al,(%eax)
  60:	07                   	pop    %es
  61:	0f 00 0b             	str    (%ebx)
  64:	0b 49 13             	or     0x13(%ecx),%ecx
  67:	00 00                	add    %al,(%eax)
  69:	08 37                	or     %dh,(%edi)
  6b:	00 49 13             	add    %cl,0x13(%ecx)
  6e:	00 00                	add    %al,(%eax)
  70:	09 26                	or     %esp,(%esi)
  72:	00 49 13             	add    %cl,0x13(%ecx)
  75:	00 00                	add    %al,(%eax)
  77:	0a 2e                	or     (%esi),%ch
  79:	00 3f                	add    %bh,(%edi)
  7b:	19 03                	sbb    %eax,(%ebx)
  7d:	0e                   	push   %cs
  7e:	3a 0b                	cmp    (%ebx),%cl
  80:	3b 0b                	cmp    (%ebx),%ecx
  82:	39 0b                	cmp    %ecx,(%ebx)
  84:	27                   	daa
  85:	19 3c 19             	sbb    %edi,(%ecx,%ebx,1)
  88:	00 00                	add    %al,(%eax)
  8a:	0b 2e                	or     (%esi),%ebp
  8c:	01 3f                	add    %edi,(%edi)
  8e:	19 03                	sbb    %eax,(%ebx)
  90:	0e                   	push   %cs
  91:	3a 0b                	cmp    (%ebx),%cl
  93:	3b 0b                	cmp    (%ebx),%ecx
  95:	39 0b                	cmp    %ecx,(%ebx)
  97:	27                   	daa
  98:	19 11                	sbb    %edx,(%ecx)
  9a:	01 12                	add    %edx,(%edx)
  9c:	06                   	push   %es
  9d:	40                   	inc    %eax
  9e:	18 7c 19 00          	sbb    %bh,0x0(%ecx,%ebx,1)
  a2:	00 0c 34             	add    %cl,(%esp,%esi,1)
  a5:	00 03                	add    %al,(%ebx)
  a7:	0e                   	push   %cs
  a8:	3a 0b                	cmp    (%ebx),%cl
  aa:	3b 0b                	cmp    (%ebx),%ecx
  ac:	39 0b                	cmp    %ecx,(%ebx)
  ae:	49                   	dec    %ecx
  af:	13 02                	adc    (%edx),%eax
  b1:	18 00                	sbb    %al,(%eax)
  b3:	00 00                	add    %al,(%eax)
  b5:	01 34 00             	add    %esi,(%eax,%eax,1)
  b8:	03 0e                	add    (%esi),%ecx
  ba:	3a 21                	cmp    (%ecx),%ah
  bc:	01 3b                	add    %edi,(%ebx)
  be:	0b 39                	or     (%ecx),%edi
  c0:	0b 49 13             	or     0x13(%ecx),%ecx
  c3:	02 18                	add    (%eax),%bl
  c5:	00 00                	add    %al,(%eax)
  c7:	02 28                	add    (%eax),%ch
  c9:	00 03                	add    %al,(%ebx)
  cb:	0e                   	push   %cs
  cc:	1c 0b                	sbb    $0xb,%al
  ce:	00 00                	add    %al,(%eax)
  d0:	03 24 00             	add    (%eax,%eax,1),%esp
  d3:	0b 0b                	or     (%ebx),%ecx
  d5:	3e 0b 03             	or     %ds:(%ebx),%eax
  d8:	0e                   	push   %cs
  d9:	00 00                	add    %al,(%eax)
  db:	04 16                	add    $0x16,%al
  dd:	00 03                	add    %al,(%ebx)
  df:	0e                   	push   %cs
  e0:	3a 0b                	cmp    (%ebx),%cl
  e2:	3b 0b                	cmp    (%ebx),%ecx
  e4:	39 0b                	cmp    %ecx,(%ebx)
  e6:	49                   	dec    %ecx
  e7:	13 00                	adc    (%eax),%eax
  e9:	00 05 34 00 03 08    	add    %al,0x8030034
  ef:	3a 21                	cmp    (%ecx),%ah
  f1:	01 3b                	add    %edi,(%ebx)
  f3:	0b 39                	or     (%ecx),%edi
  f5:	0b 49 13             	or     0x13(%ecx),%ecx
  f8:	02 18                	add    (%eax),%bl
  fa:	00 00                	add    %al,(%eax)
  fc:	06                   	push   %es
  fd:	05 00 03 08 3a       	add    $0x3a080300,%eax
 102:	21 01                	and    %eax,(%ecx)
 104:	3b 0b                	cmp    (%ebx),%ecx
 106:	39 0b                	cmp    %ecx,(%ebx)
 108:	49                   	dec    %ecx
 109:	13 02                	adc    (%edx),%eax
 10b:	18 00                	sbb    %al,(%eax)
 10d:	00 07                	add    %al,(%edi)
 10f:	0b 01                	or     (%ecx),%eax
 111:	11 01                	adc    %eax,(%ecx)
 113:	12 06                	adc    (%esi),%al
 115:	00 00                	add    %al,(%eax)
 117:	08 2e                	or     %ch,(%esi)
 119:	01 3f                	add    %edi,(%edi)
 11b:	19 03                	sbb    %eax,(%ebx)
 11d:	0e                   	push   %cs
 11e:	3a 21                	cmp    (%ecx),%ah
 120:	01 3b                	add    %edi,(%ebx)
 122:	0b 39                	or     (%ecx),%edi
 124:	21 06                	and    %eax,(%esi)
 126:	27                   	daa
 127:	19 11                	sbb    %edx,(%ecx)
 129:	01 12                	add    %edx,(%edx)
 12b:	06                   	push   %es
 12c:	40                   	inc    %eax
 12d:	18 7c 19 01          	sbb    %bh,0x1(%ecx,%ebx,1)
 131:	13 00                	adc    (%eax),%eax
 133:	00 09                	add    %cl,(%ecx)
 135:	26 00 49 13          	add    %cl,%es:0x13(%ecx)
 139:	00 00                	add    %al,(%eax)
 13b:	0a 2e                	or     (%esi),%ch
 13d:	01 3f                	add    %edi,(%edi)
 13f:	19 03                	sbb    %eax,(%ebx)
 141:	0e                   	push   %cs
 142:	3a 21                	cmp    (%ecx),%ah
 144:	01 3b                	add    %edi,(%ebx)
 146:	0b 39                	or     (%ecx),%edi
 148:	21 06                	and    %eax,(%esi)
 14a:	27                   	daa
 14b:	19 11                	sbb    %edx,(%ecx)
 14d:	01 12                	add    %edx,(%edx)
 14f:	06                   	push   %es
 150:	40                   	inc    %eax
 151:	18 7a 19             	sbb    %bh,0x19(%edx)
 154:	01 13                	add    %edx,(%ebx)
 156:	00 00                	add    %al,(%eax)
 158:	0b 0d 00 03 08 3a    	or     0x3a080300,%ecx
 15e:	21 03                	and    %eax,(%ebx)
 160:	3b 0b                	cmp    (%ebx),%ecx
 162:	39 21                	cmp    %esp,(%ecx)
 164:	09 49 13             	or     %ecx,0x13(%ecx)
 167:	38 0b                	cmp    %cl,(%ebx)
 169:	00 00                	add    %al,(%eax)
 16b:	0c 01                	or     $0x1,%al
 16d:	01 49 13             	add    %ecx,0x13(%ecx)
 170:	01 13                	add    %edx,(%ebx)
 172:	00 00                	add    %al,(%eax)
 174:	0d 21 00 49 13       	or     $0x13490021,%eax
 179:	2f                   	das
 17a:	0b 00                	or     (%eax),%eax
 17c:	00 0e                	add    %cl,(%esi)
 17e:	0f 00 0b             	str    (%ebx)
 181:	21 04 49             	and    %eax,(%ecx,%ecx,2)
 184:	13 00                	adc    (%eax),%eax
 186:	00 0f                	add    %cl,(%edi)
 188:	05 00 03 0e 3a       	add    $0x3a0e0300,%eax
 18d:	21 01                	and    %eax,(%ecx)
 18f:	3b 0b                	cmp    (%ebx),%ecx
 191:	39 0b                	cmp    %ecx,(%ebx)
 193:	49                   	dec    %ecx
 194:	13 02                	adc    (%edx),%eax
 196:	18 00                	sbb    %al,(%eax)
 198:	00 10                	add    %dl,(%eax)
 19a:	2e 00 3f             	add    %bh,%cs:(%edi)
 19d:	19 03                	sbb    %eax,(%ebx)
 19f:	0e                   	push   %cs
 1a0:	3a 21                	cmp    (%ecx),%ah
 1a2:	01 3b                	add    %edi,(%ebx)
 1a4:	0b 39                	or     (%ecx),%edi
 1a6:	0b 27                	or     (%edi),%esp
 1a8:	19 49 13             	sbb    %ecx,0x13(%ecx)
 1ab:	11 01                	adc    %eax,(%ecx)
 1ad:	12 06                	adc    (%esi),%al
 1af:	40                   	inc    %eax
 1b0:	18 7a 19             	sbb    %bh,0x19(%edx)
 1b3:	00 00                	add    %al,(%eax)
 1b5:	11 11                	adc    %edx,(%ecx)
 1b7:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
 1bd:	1f                   	pop    %ds
 1be:	1b 1f                	sbb    (%edi),%ebx
 1c0:	11 01                	adc    %eax,(%ecx)
 1c2:	12 06                	adc    (%esi),%al
 1c4:	10 17                	adc    %dl,(%edi)
 1c6:	00 00                	add    %al,(%eax)
 1c8:	12 24 00             	adc    (%eax,%eax,1),%ah
 1cb:	0b 0b                	or     (%ebx),%ecx
 1cd:	3e 0b 03             	or     %ds:(%ebx),%eax
 1d0:	08 00                	or     %al,(%eax)
 1d2:	00 13                	add    %dl,(%ebx)
 1d4:	13 01                	adc    (%ecx),%eax
 1d6:	03 0e                	add    (%esi),%ecx
 1d8:	0b 0b                	or     (%ebx),%ecx
 1da:	3a 0b                	cmp    (%ebx),%cl
 1dc:	3b 0b                	cmp    (%ebx),%ecx
 1de:	39 0b                	cmp    %ecx,(%ebx)
 1e0:	01 13                	add    %edx,(%ebx)
 1e2:	00 00                	add    %al,(%eax)
 1e4:	14 04                	adc    $0x4,%al
 1e6:	01 03                	add    %eax,(%ebx)
 1e8:	0e                   	push   %cs
 1e9:	3e 0b 0b             	or     %ds:(%ebx),%ecx
 1ec:	0b 49 13             	or     0x13(%ecx),%ecx
 1ef:	3a 0b                	cmp    (%ebx),%cl
 1f1:	3b 0b                	cmp    (%ebx),%ecx
 1f3:	39 0b                	cmp    %ecx,(%ebx)
 1f5:	01 13                	add    %edx,(%ebx)
 1f7:	00 00                	add    %al,(%eax)
 1f9:	15 28 00 03 08       	adc    $0x8030028,%eax
 1fe:	1c 0b                	sbb    $0xb,%al
 200:	00 00                	add    %al,(%eax)
 202:	16                   	push   %ss
 203:	0f 00 0b             	str    (%ebx)
 206:	0b 03                	or     (%ebx),%eax
 208:	0e                   	push   %cs
 209:	49                   	dec    %ecx
 20a:	13 00                	adc    (%eax),%eax
 20c:	00 17                	add    %dl,(%edi)
 20e:	0f 00 0b             	str    (%ebx)
 211:	0b 00                	or     (%eax),%eax
 213:	00 18                	add    %bl,(%eax)
 215:	18 00                	sbb    %al,(%eax)
 217:	00 00                	add    %al,(%eax)
 219:	19 37                	sbb    %esi,(%edi)
 21b:	00 49 13             	add    %cl,0x13(%ecx)
 21e:	00 00                	add    %al,(%eax)
 220:	1a 0b                	sbb    (%ebx),%cl
 222:	01 11                	add    %edx,(%ecx)
 224:	01 12                	add    %edx,(%edx)
 226:	06                   	push   %es
 227:	01 13                	add    %edx,(%ebx)
 229:	00 00                	add    %al,(%eax)
 22b:	1b 2e                	sbb    (%esi),%ebp
 22d:	01 3f                	add    %edi,(%edi)
 22f:	19 03                	sbb    %eax,(%ebx)
 231:	0e                   	push   %cs
 232:	3a 0b                	cmp    (%ebx),%cl
 234:	3b 0b                	cmp    (%ebx),%ecx
 236:	39 0b                	cmp    %ecx,(%ebx)
 238:	27                   	daa
 239:	19 11                	sbb    %edx,(%ecx)
 23b:	01 12                	add    %edx,(%edx)
 23d:	06                   	push   %es
 23e:	40                   	inc    %eax
 23f:	18 7a 19             	sbb    %bh,0x19(%edx)
 242:	00 00                	add    %al,(%eax)
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	1c 00                	sbb    $0x0,%al
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	00 00                	add    %al,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	04 00                	add    $0x0,%al
   c:	00 00                	add    %al,(%eax)
   e:	00 00                	add    %al,(%eax)
  10:	00 7e 00             	add    %bh,0x0(%esi)
  13:	00 74 03 00          	add    %dh,0x0(%ebx,%eax,1)
	...
  1f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  22:	00 00                	add    %al,(%eax)
  24:	02 00                	add    (%eax),%al
  26:	26 00 00             	add    %al,%es:(%eax)
  29:	00 04 00             	add    %al,(%eax,%eax,1)
  2c:	00 00                	add    %al,(%eax)
  2e:	00 00                	add    %al,(%eax)
  30:	74 81                	je     ffffffb3 <_cursor+0xffff790b>
  32:	00 00                	add    %al,(%eax)
  34:	41                   	inc    %ecx
	...
  3d:	00 00                	add    %al,(%eax)
  3f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  42:	00 00                	add    %al,(%eax)
  44:	02 00                	add    (%eax),%al
  46:	f5                   	cmc
  47:	00 00                	add    %al,(%eax)
  49:	00 04 00             	add    %al,(%eax,%eax,1)
  4c:	00 00                	add    %al,(%eax)
  4e:	00 00                	add    %al,(%eax)
  50:	b5 81                	mov    $0x81,%ch
  52:	00 00                	add    %al,(%eax)
  54:	6f                   	outsl  %ds:(%esi),(%dx)
  55:	04 00                	add    $0x0,%al
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	2f                   	das
   1:	68 6f 6d 65 2f       	push   $0x2f656d6f
   6:	6a 63                	push   $0x63
   8:	68 61 75 2f 44       	push   $0x442f7561
   d:	6f                   	outsl  %ds:(%esi),(%dx)
   e:	63 75 6d             	arpl   %esi,0x6d(%ebp)
  11:	65 6e                	outsb  %gs:(%esi),(%dx)
  13:	74 73                	je     88 <BIOS_A20_ERROR_MSG_LEN+0x3c>
  15:	2f                   	das
  16:	47                   	inc    %edi
  17:	69 74 48 75 62 2f 53 	imul   $0x74532f62,0x75(%eax,%ecx,2),%esi
  1e:	74 
  1f:	65 69 6e 65 72 4f 53 	imul   $0x2f534f72,%gs:0x65(%esi),%ebp
  26:	2f 
  27:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  2a:	74 2f                	je     5b <BIOS_A20_ERROR_MSG_LEN+0xf>
  2c:	62 69 6f             	bound  %ebp,0x6f(%ecx)
  2f:	73 2f                	jae    60 <BIOS_A20_ERROR_MSG_LEN+0x14>
  31:	73 74                	jae    a7 <BIOS_A20_ERROR_MSG_LEN+0x5b>
  33:	61                   	popa
  34:	67 65 32 2f          	xor    %gs:(%bx),%ch
  38:	73 65                	jae    9f <BIOS_A20_ERROR_MSG_LEN+0x53>
  3a:	63 6f 6e             	arpl   %ebp,0x6e(%edi)
  3d:	64 5f                	fs pop %edi
  3f:	73 74                	jae    b5 <BIOS_A20_ERROR_MSG_LEN+0x69>
  41:	61                   	popa
  42:	67 65 2e 73 00       	addr16 gs jae,pn 47 <PM_SUCCESS_MSG_LEN+0x11>
  47:	2f                   	das
  48:	68 6f 6d 65 2f       	push   $0x2f656d6f
  4d:	6a 63                	push   $0x63
  4f:	68 61 75 2f 44       	push   $0x442f7561
  54:	6f                   	outsl  %ds:(%esi),(%dx)
  55:	63 75 6d             	arpl   %esi,0x6d(%ebp)
  58:	65 6e                	outsb  %gs:(%esi),(%dx)
  5a:	74 73                	je     cf <BIOS_A20_ERROR_MSG_LEN+0x83>
  5c:	2f                   	das
  5d:	47                   	inc    %edi
  5e:	69 74 48 75 62 2f 53 	imul   $0x74532f62,0x75(%eax,%ecx,2),%esi
  65:	74 
  66:	65 69 6e 65 72 4f 53 	imul   $0x2f534f72,%gs:0x65(%esi),%ebp
  6d:	2f 
  6e:	62 75 69             	bound  %esi,0x69(%ebp)
  71:	6c                   	insb   (%dx),%es:(%edi)
  72:	64 2f                	fs das
  74:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  77:	74 2f                	je     a8 <BIOS_A20_ERROR_MSG_LEN+0x5c>
  79:	62 69 6f             	bound  %ebp,0x6f(%ecx)
  7c:	73 2f                	jae    ad <BIOS_A20_ERROR_MSG_LEN+0x61>
  7e:	73 74                	jae    f4 <BIOS_A20_ERROR_MSG_LEN+0xa8>
  80:	61                   	popa
  81:	67 65 32 00          	xor    %gs:(%bx,%si),%al
  85:	47                   	inc    %edi
  86:	4e                   	dec    %esi
  87:	55                   	push   %ebp
  88:	20 41 53             	and    %al,0x53(%ecx)
  8b:	20 32                	and    %dh,(%edx)
  8d:	2e 34 37             	cs xor $0x37,%al
  90:	00 62 6f             	add    %ah,0x6f(%edx)
  93:	6f                   	outsl  %ds:(%esi),(%dx)
  94:	74 6c                	je     102 <BIOS_A20_ERROR_MSG_LEN+0xb6>
  96:	6f                   	outsl  %ds:(%esi),(%dx)
  97:	61                   	popa
  98:	64 65 72 5f          	fs gs jb fb <BIOS_A20_ERROR_MSG_LEN+0xaf>
  9c:	6d                   	insl   (%dx),%es:(%edi)
  9d:	61                   	popa
  9e:	69 6e 00 47 4e 55 20 	imul   $0x20554e47,0x0(%esi),%ebp
  a5:	43                   	inc    %ebx
  a6:	39 39                	cmp    %edi,(%ecx)
  a8:	20 31                	and    %dh,(%ecx)
  aa:	36 2e 32 2e          	ss xor %cs:(%esi),%ch
  ae:	30 20                	xor    %ah,(%eax)
  b0:	2d 6d 67 65 6e       	sub    $0x6e65676d,%eax
  b5:	65 72 61             	gs jb  119 <BIOS_A20_ERROR_MSG_LEN+0xcd>
  b8:	6c                   	insb   (%dx),%es:(%edi)
  b9:	2d 72 65 67 73       	sub    $0x73676572,%eax
  be:	2d 6f 6e 6c 79       	sub    $0x796c6e6f,%eax
  c3:	20 2d 6d 74 75 6e    	and    %ch,0x6e75746d
  c9:	65 3d 67 65 6e 65    	gs cmp $0x656e6567,%eax
  cf:	72 69                	jb     13a <BIOS_A20_ERROR_MSG_LEN+0xee>
  d1:	63 20                	arpl   %esp,(%eax)
  d3:	2d 6d 61 72 63       	sub    $0x6372616d,%eax
  d8:	68 3d 70 65 6e       	push   $0x6e65703d
  dd:	74 69                	je     148 <BIOS_A20_ERROR_MSG_LEN+0xfc>
  df:	75 6d                	jne    14e <BIOS_A20_ERROR_MSG_LEN+0x102>
  e1:	70 72                	jo     155 <BIOS_A20_ERROR_MSG_LEN+0x109>
  e3:	6f                   	outsl  %ds:(%esi),(%dx)
  e4:	20 2d 67 20 2d 73    	and    %ch,0x732d2067
  ea:	74 64                	je     150 <BIOS_A20_ERROR_MSG_LEN+0x104>
  ec:	3d 67 6e 75 39       	cmp    $0x39756e67,%eax
  f1:	39 20                	cmp    %esp,(%eax)
  f3:	2d 66 66 72 65       	sub    $0x65726666,%eax
  f8:	65 73 74             	gs jae 16f <BIOS_A20_ERROR_MSG_LEN+0x123>
  fb:	61                   	popa
  fc:	6e                   	outsb  %ds:(%esi),(%dx)
  fd:	64 69 6e 67 00 75 6e 	imul   $0x736e7500,%fs:0x67(%esi),%ebp
 104:	73 
 105:	69 67 6e 65 64 20 63 	imul   $0x63206465,0x6e(%edi),%esp
 10c:	68 61 72 00 73       	push   $0x73007261
 111:	68 6f 72 74 20       	push   $0x2074726f
 116:	75 6e                	jne    186 <BIOS_A20_ERROR_MSG_LEN+0x13a>
 118:	73 69                	jae    183 <BIOS_A20_ERROR_MSG_LEN+0x137>
 11a:	67 6e                	outsb  %ds:(%si),(%dx)
 11c:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
 121:	74 00                	je     123 <BIOS_A20_ERROR_MSG_LEN+0xd7>
 123:	50                   	push   %eax
 124:	4d                   	dec    %ebp
 125:	5f                   	pop    %edi
 126:	4d                   	dec    %ebp
 127:	53                   	push   %ebx
 128:	47                   	inc    %edi
 129:	00 56 47             	add    %dl,0x47(%esi)
 12c:	41                   	inc    %ecx
 12d:	5f                   	pop    %edi
 12e:	50                   	push   %eax
 12f:	72 69                	jb     19a <BIOS_A20_ERROR_MSG_LEN+0x14e>
 131:	6e                   	outsb  %ds:(%esi),(%dx)
 132:	74 00                	je     134 <BIOS_A20_ERROR_MSG_LEN+0xe8>
 134:	6c                   	insb   (%dx),%es:(%edi)
 135:	6f                   	outsl  %ds:(%esi),(%dx)
 136:	6e                   	outsb  %ds:(%esi),(%dx)
 137:	67 20 6c 6f          	and    %ch,0x6f(%si)
 13b:	6e                   	outsb  %ds:(%esi),(%dx)
 13c:	67 20 75 6e          	and    %dh,0x6e(%di)
 140:	73 69                	jae    1ab <BIOS_A20_ERROR_MSG_LEN+0x15f>
 142:	67 6e                	outsb  %ds:(%si),(%dx)
 144:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
 149:	74 00                	je     14b <BIOS_A20_ERROR_MSG_LEN+0xff>
 14b:	56                   	push   %esi
 14c:	47                   	inc    %edi
 14d:	41                   	inc    %ecx
 14e:	5f                   	pop    %edi
 14f:	50                   	push   %eax
 150:	72 69                	jb     1bb <BIOS_A20_ERROR_MSG_LEN+0x16f>
 152:	6e                   	outsb  %ds:(%esi),(%dx)
 153:	74 66                	je     1bb <BIOS_A20_ERROR_MSG_LEN+0x16f>
 155:	00 6c 6f 6e          	add    %ch,0x6e(%edi,%ebp,2)
 159:	67 20 6c 6f          	and    %ch,0x6f(%si)
 15d:	6e                   	outsb  %ds:(%esi),(%dx)
 15e:	67 20 69 6e          	and    %ch,0x6e(%bx,%di)
 162:	74 00                	je     164 <BIOS_A20_ERROR_MSG_LEN+0x118>
 164:	73 68                	jae    1ce <BIOS_A20_ERROR_MSG_LEN+0x182>
 166:	6f                   	outsl  %ds:(%esi),(%dx)
 167:	72 74                	jb     1dd <BIOS_A20_ERROR_MSG_LEN+0x191>
 169:	20 69 6e             	and    %ch,0x6e(%ecx)
 16c:	74 00                	je     16e <BIOS_A20_ERROR_MSG_LEN+0x122>
 16e:	56                   	push   %esi
 16f:	47                   	inc    %edi
 170:	41                   	inc    %ecx
 171:	5f                   	pop    %edi
 172:	43                   	inc    %ebx
 173:	6c                   	insb   (%dx),%es:(%edi)
 174:	65 61                	gs popa
 176:	72 53                	jb     1cb <BIOS_A20_ERROR_MSG_LEN+0x17f>
 178:	63 72 65             	arpl   %esi,0x65(%edx)
 17b:	65 6e                	outsb  %gs:(%esi),(%dx)
 17d:	00 62 75             	add    %ah,0x75(%edx)
 180:	66 66 65 72 5f       	data16 data16 gs jb 1e4 <BIOS_A20_ERROR_MSG_LEN+0x198>
 185:	6c                   	insb   (%dx),%es:(%edi)
 186:	65 6e                	outsb  %gs:(%esi),(%dx)
 188:	00 56 47             	add    %dl,0x47(%esi)
 18b:	41                   	inc    %ecx
 18c:	5f                   	pop    %edi
 18d:	46                   	inc    %esi
 18e:	52                   	push   %edx
 18f:	41                   	inc    %ecx
 190:	4d                   	dec    %ebp
 191:	45                   	inc    %ebp
 192:	42                   	inc    %edx
 193:	55                   	push   %ebp
 194:	46                   	inc    %esi
 195:	46                   	inc    %esi
 196:	45                   	inc    %ebp
 197:	52                   	push   %edx
 198:	00 56 47             	add    %dl,0x47(%esi)
 19b:	41                   	inc    %ecx
 19c:	5f                   	pop    %edi
 19d:	50                   	push   %eax
 19e:	72 69                	jb     209 <BIOS_A20_ERROR_MSG_LEN+0x1bd>
 1a0:	6e                   	outsb  %ds:(%esi),(%dx)
 1a1:	74 49                	je     1ec <BIOS_A20_ERROR_MSG_LEN+0x1a0>
 1a3:	6e                   	outsb  %ds:(%esi),(%dx)
 1a4:	74 00                	je     1a6 <BIOS_A20_ERROR_MSG_LEN+0x15a>
 1a6:	42                   	inc    %edx
 1a7:	52                   	push   %edx
 1a8:	49                   	dec    %ecx
 1a9:	47                   	inc    %edi
 1aa:	48                   	dec    %eax
 1ab:	54                   	push   %esp
 1ac:	5f                   	pop    %edi
 1ad:	57                   	push   %edi
 1ae:	48                   	dec    %eax
 1af:	49                   	dec    %ecx
 1b0:	54                   	push   %esp
 1b1:	45                   	inc    %ebp
 1b2:	00 56 47             	add    %dl,0x47(%esi)
 1b5:	41                   	inc    %ecx
 1b6:	5f                   	pop    %edi
 1b7:	43                   	inc    %ebx
 1b8:	75 72                	jne    22c <BIOS_A20_ERROR_MSG_LEN+0x1e0>
 1ba:	73 6f                	jae    22b <BIOS_A20_ERROR_MSG_LEN+0x1df>
 1bc:	72 00                	jb     1be <BIOS_A20_ERROR_MSG_LEN+0x172>
 1be:	53                   	push   %ebx
 1bf:	43                   	inc    %ebx
 1c0:	52                   	push   %edx
 1c1:	45                   	inc    %ebp
 1c2:	45                   	inc    %ebp
 1c3:	4e                   	dec    %esi
 1c4:	5f                   	pop    %edi
 1c5:	48                   	dec    %eax
 1c6:	45                   	inc    %ebp
 1c7:	49                   	dec    %ecx
 1c8:	47                   	inc    %edi
 1c9:	48                   	dec    %eax
 1ca:	54                   	push   %esp
 1cb:	00 56 47             	add    %dl,0x47(%esi)
 1ce:	41                   	inc    %ecx
 1cf:	5f                   	pop    %edi
 1d0:	47                   	inc    %edi
 1d1:	65 74 43             	gs je  217 <BIOS_A20_ERROR_MSG_LEN+0x1cb>
 1d4:	6f                   	outsl  %ds:(%esi),(%dx)
 1d5:	6c                   	insb   (%dx),%es:(%edi)
 1d6:	6f                   	outsl  %ds:(%esi),(%dx)
 1d7:	72 41                	jb     21a <BIOS_A20_ERROR_MSG_LEN+0x1ce>
 1d9:	74 74                	je     24f <BIOS_A20_ERROR_MSG_LEN+0x203>
 1db:	72 69                	jb     246 <BIOS_A20_ERROR_MSG_LEN+0x1fa>
 1dd:	62 75 74             	bound  %esi,0x74(%ebp)
 1e0:	65 73 00             	gs jae 1e3 <BIOS_A20_ERROR_MSG_LEN+0x197>
 1e3:	76 61                	jbe    246 <BIOS_A20_ERROR_MSG_LEN+0x1fa>
 1e5:	6c                   	insb   (%dx),%es:(%edi)
 1e6:	75 65                	jne    24d <BIOS_A20_ERROR_MSG_LEN+0x201>
 1e8:	00 5f 63             	add    %bl,0x63(%edi)
 1eb:	75 72                	jne    25f <BIOS_A20_ERROR_MSG_LEN+0x213>
 1ed:	73 6f                	jae    25e <BIOS_A20_ERROR_MSG_LEN+0x212>
 1ef:	72 00                	jb     1f1 <BIOS_A20_ERROR_MSG_LEN+0x1a5>
 1f1:	75 69                	jne    25c <BIOS_A20_ERROR_MSG_LEN+0x210>
 1f3:	6e                   	outsb  %ds:(%esi),(%dx)
 1f4:	74 38                	je     22e <BIOS_A20_ERROR_MSG_LEN+0x1e2>
 1f6:	5f                   	pop    %edi
 1f7:	74 00                	je     1f9 <BIOS_A20_ERROR_MSG_LEN+0x1ad>
 1f9:	63 68 61             	arpl   %ebp,0x61(%eax)
 1fc:	72 5f                	jb     25d <BIOS_A20_ERROR_MSG_LEN+0x211>
 1fe:	61                   	popa
 1ff:	72 67                	jb     268 <BIOS_A20_ERROR_MSG_LEN+0x21c>
 201:	00 59 45             	add    %bl,0x45(%ecx)
 204:	4c                   	dec    %esp
 205:	4c                   	dec    %esp
 206:	4f                   	dec    %edi
 207:	57                   	push   %edi
 208:	00 47 52             	add    %al,0x52(%edi)
 20b:	41                   	inc    %ecx
 20c:	59                   	pop    %ecx
 20d:	00 42 52             	add    %al,0x52(%edx)
 210:	49                   	dec    %ecx
 211:	47                   	inc    %edi
 212:	48                   	dec    %eax
 213:	54                   	push   %esp
 214:	5f                   	pop    %edi
 215:	42                   	inc    %edx
 216:	4c                   	dec    %esp
 217:	55                   	push   %ebp
 218:	45                   	inc    %ebp
 219:	00 73 74             	add    %dh,0x74(%ebx)
 21c:	72 69                	jb     287 <BIOS_A20_ERROR_MSG_LEN+0x23b>
 21e:	6e                   	outsb  %ds:(%esi),(%dx)
 21f:	67 5f                	addr16 pop %edi
 221:	61                   	popa
 222:	72 67                	jb     28b <BIOS_A20_ERROR_MSG_LEN+0x23f>
 224:	00 56 47             	add    %dl,0x47(%esi)
 227:	41                   	inc    %ecx
 228:	5f                   	pop    %edi
 229:	47                   	inc    %edi
 22a:	65 74 43             	gs je  270 <BIOS_A20_ERROR_MSG_LEN+0x224>
 22d:	75 72                	jne    2a1 <BIOS_A20_ERROR_MSG_LEN+0x255>
 22f:	73 6f                	jae    2a0 <BIOS_A20_ERROR_MSG_LEN+0x254>
 231:	72 00                	jb     233 <BIOS_A20_ERROR_MSG_LEN+0x1e7>
 233:	56                   	push   %esi
 234:	47                   	inc    %edi
 235:	41                   	inc    %ecx
 236:	5f                   	pop    %edi
 237:	43                   	inc    %ebx
 238:	4f                   	dec    %edi
 239:	4c                   	dec    %esp
 23a:	4f                   	dec    %edi
 23b:	52                   	push   %edx
 23c:	5f                   	pop    %edi
 23d:	41                   	inc    %ecx
 23e:	54                   	push   %esp
 23f:	54                   	push   %esp
 240:	52                   	push   %edx
 241:	49                   	dec    %ecx
 242:	42                   	inc    %edx
 243:	55                   	push   %ebp
 244:	54                   	push   %esp
 245:	45                   	inc    %ebp
 246:	00 56 47             	add    %dl,0x47(%esi)
 249:	41                   	inc    %ecx
 24a:	5f                   	pop    %edi
 24b:	50                   	push   %eax
 24c:	72 69                	jb     2b7 <BIOS_A20_ERROR_MSG_LEN+0x26b>
 24e:	6e                   	outsb  %ds:(%esi),(%dx)
 24f:	74 50                	je     2a1 <BIOS_A20_ERROR_MSG_LEN+0x255>
 251:	6f                   	outsl  %ds:(%esi),(%dx)
 252:	69 6e 74 65 72 00 75 	imul   $0x75007265,0x74(%esi),%ebp
 259:	69 6e 74 33 32 5f 74 	imul   $0x745f3233,0x74(%esi),%ebp
 260:	00 42 4c             	add    %al,0x4c(%edx)
 263:	41                   	inc    %ecx
 264:	43                   	inc    %ebx
 265:	4b                   	dec    %ebx
 266:	00 75 69             	add    %dh,0x69(%ebp)
 269:	6e                   	outsb  %ds:(%esi),(%dx)
 26a:	74 31                	je     29d <BIOS_A20_ERROR_MSG_LEN+0x251>
 26c:	36 5f                	ss pop %edi
 26e:	74 00                	je     270 <BIOS_A20_ERROR_MSG_LEN+0x224>
 270:	42                   	inc    %edx
 271:	52                   	push   %edx
 272:	49                   	dec    %ecx
 273:	47                   	inc    %edi
 274:	48                   	dec    %eax
 275:	54                   	push   %esp
 276:	5f                   	pop    %edi
 277:	47                   	inc    %edi
 278:	52                   	push   %edx
 279:	45                   	inc    %ebp
 27a:	45                   	inc    %ebp
 27b:	4e                   	dec    %esi
 27c:	00 56 47             	add    %dl,0x47(%esi)
 27f:	41                   	inc    %ecx
 280:	5f                   	pop    %edi
 281:	53                   	push   %ebx
 282:	65 74 43             	gs je  2c8 <BIOS_A20_ERROR_MSG_LEN+0x27c>
 285:	6f                   	outsl  %ds:(%esi),(%dx)
 286:	6c                   	insb   (%dx),%es:(%edi)
 287:	6f                   	outsl  %ds:(%esi),(%dx)
 288:	72 41                	jb     2cb <BIOS_A20_ERROR_MSG_LEN+0x27f>
 28a:	74 74                	je     300 <BIOS_A20_ERROR_MSG_LEN+0x2b4>
 28c:	72 69                	jb     2f7 <BIOS_A20_ERROR_MSG_LEN+0x2ab>
 28e:	62 75 74             	bound  %esi,0x74(%ebp)
 291:	65 73 00             	gs jae 294 <BIOS_A20_ERROR_MSG_LEN+0x248>
 294:	42                   	inc    %edx
 295:	52                   	push   %edx
 296:	49                   	dec    %ecx
 297:	47                   	inc    %edi
 298:	48                   	dec    %eax
 299:	54                   	push   %esp
 29a:	5f                   	pop    %edi
 29b:	52                   	push   %edx
 29c:	45                   	inc    %ebp
 29d:	44                   	inc    %esp
 29e:	00 69 6e             	add    %ch,0x6e(%ecx)
 2a1:	74 5f                	je     302 <BIOS_A20_ERROR_MSG_LEN+0x2b6>
 2a3:	61                   	popa
 2a4:	72 67                	jb     30d <BIOS_A20_ERROR_MSG_LEN+0x2c1>
 2a6:	00 73 69             	add    %dh,0x69(%ebx)
 2a9:	7a 65                	jp     310 <BIOS_A20_ERROR_MSG_LEN+0x2c4>
 2ab:	5f                   	pop    %edi
 2ac:	74 00                	je     2ae <BIOS_A20_ERROR_MSG_LEN+0x262>
 2ae:	70 74                	jo     324 <BIOS_A20_ERROR_MSG_LEN+0x2d8>
 2b0:	72 5f                	jb     311 <BIOS_A20_ERROR_MSG_LEN+0x2c5>
 2b2:	61                   	popa
 2b3:	72 67                	jb     31c <BIOS_A20_ERROR_MSG_LEN+0x2d0>
 2b5:	00 62 75             	add    %ah,0x75(%edx)
 2b8:	66 66 65 72 00       	data16 data16 gs jb 2bd <BIOS_A20_ERROR_MSG_LEN+0x271>
 2bd:	53                   	push   %ebx
 2be:	43                   	inc    %ebx
 2bf:	52                   	push   %edx
 2c0:	45                   	inc    %ebp
 2c1:	45                   	inc    %ebp
 2c2:	4e                   	dec    %esi
 2c3:	5f                   	pop    %edi
 2c4:	57                   	push   %edi
 2c5:	49                   	dec    %ecx
 2c6:	44                   	inc    %esp
 2c7:	54                   	push   %esp
 2c8:	48                   	dec    %eax
 2c9:	00 5f 5f             	add    %bl,0x5f(%edi)
 2cc:	62 75 69             	bound  %esi,0x69(%ebp)
 2cf:	6c                   	insb   (%dx),%es:(%edi)
 2d0:	74 69                	je     33b <BIOS_A20_ERROR_MSG_LEN+0x2ef>
 2d2:	6e                   	outsb  %ds:(%esi),(%dx)
 2d3:	5f                   	pop    %edi
 2d4:	76 61                	jbe    337 <BIOS_A20_ERROR_MSG_LEN+0x2eb>
 2d6:	5f                   	pop    %edi
 2d7:	6c                   	insb   (%dx),%es:(%edi)
 2d8:	69 73 74 00 42 52 49 	imul   $0x49524200,0x74(%ebx),%esi
 2df:	47                   	inc    %edi
 2e0:	48                   	dec    %eax
 2e1:	54                   	push   %esp
 2e2:	5f                   	pop    %edi
 2e3:	43                   	inc    %ebx
 2e4:	59                   	pop    %ecx
 2e5:	41                   	inc    %ecx
 2e6:	4e                   	dec    %esi
 2e7:	00 56 47             	add    %dl,0x47(%esi)
 2ea:	41                   	inc    %ecx
 2eb:	5f                   	pop    %edi
 2ec:	50                   	push   %eax
 2ed:	75 74                	jne    363 <BIOS_A20_ERROR_MSG_LEN+0x317>
 2ef:	43                   	inc    %ebx
 2f0:	68 61 72 00 56       	push   $0x56007261
 2f5:	47                   	inc    %edi
 2f6:	41                   	inc    %ecx
 2f7:	5f                   	pop    %edi
 2f8:	41                   	inc    %ecx
 2f9:	74 74                	je     36f <BIOS_A20_ERROR_MSG_LEN+0x323>
 2fb:	72 69                	jb     366 <BIOS_A20_ERROR_MSG_LEN+0x31a>
 2fd:	62 75 74             	bound  %esi,0x74(%ebp)
 300:	65 00 42 52          	add    %al,%gs:0x52(%edx)
 304:	4f                   	dec    %edi
 305:	57                   	push   %edi
 306:	4e                   	dec    %esi
 307:	00 48 45             	add    %cl,0x45(%eax)
 30a:	58                   	pop    %eax
 30b:	5f                   	pop    %edi
 30c:	43                   	inc    %ebx
 30d:	48                   	dec    %eax
 30e:	41                   	inc    %ecx
 30f:	52                   	push   %edx
 310:	53                   	push   %ebx
 311:	00 42 52             	add    %al,0x52(%edx)
 314:	49                   	dec    %ecx
 315:	47                   	inc    %edi
 316:	48                   	dec    %eax
 317:	54                   	push   %esp
 318:	5f                   	pop    %edi
 319:	4d                   	dec    %ebp
 31a:	41                   	inc    %ecx
 31b:	47                   	inc    %edi
 31c:	45                   	inc    %ebp
 31d:	4e                   	dec    %esi
 31e:	54                   	push   %esp
 31f:	41                   	inc    %ecx
 320:	00 5f 5f             	add    %bl,0x5f(%edi)
 323:	67 6e                	outsb  %ds:(%si),(%dx)
 325:	75 63                	jne    38a <BIOS_A20_ERROR_MSG_LEN+0x33e>
 327:	5f                   	pop    %edi
 328:	76 61                	jbe    38b <BIOS_A20_ERROR_MSG_LEN+0x33f>
 32a:	5f                   	pop    %edi
 32b:	6c                   	insb   (%dx),%es:(%edi)
 32c:	69 73 74 00 64 69 67 	imul   $0x67696400,0x74(%ebx),%esi
 333:	69 74 00 56 47 41 5f 	imul   $0x535f4147,0x56(%eax,%eax,1),%esi
 33a:	53 
 33b:	65 74 43             	gs je  381 <BIOS_A20_ERROR_MSG_LEN+0x335>
 33e:	75 72                	jne    3b2 <BIOS_A20_ERROR_MSG_LEN+0x366>
 340:	73 6f                	jae    3b1 <BIOS_A20_ERROR_MSG_LEN+0x365>
 342:	72 00                	jb     344 <BIOS_A20_ERROR_MSG_LEN+0x2f8>
 344:	74 65                	je     3ab <BIOS_A20_ERROR_MSG_LEN+0x35f>
 346:	78 74                	js     3bc <BIOS_A20_ERROR_MSG_LEN+0x370>
 348:	5f                   	pop    %edi
 349:	61                   	popa
 34a:	74 74                	je     3c0 <BIOS_A20_ERROR_MSG_LEN+0x374>
 34c:	72 00                	jb     34e <BIOS_A20_ERROR_MSG_LEN+0x302>
 34e:	56                   	push   %esi
 34f:	47                   	inc    %edi
 350:	41                   	inc    %ecx
 351:	5f                   	pop    %edi
 352:	53                   	push   %ebx
 353:	63 72 6f             	arpl   %esi,0x6f(%edx)
 356:	6c                   	insb   (%dx),%es:(%edi)
 357:	6c                   	insb   (%dx),%es:(%edi)
 358:	53                   	push   %ebx
 359:	63 72 65             	arpl   %esi,0x65(%edx)
 35c:	65 6e                	outsb  %gs:(%esi),(%dx)
	...

Disassembly of section .debug_line_str:

00000000 <.debug_line_str>:
   0:	2f                   	das
   1:	68 6f 6d 65 2f       	push   $0x2f656d6f
   6:	6a 63                	push   $0x63
   8:	68 61 75 2f 44       	push   $0x442f7561
   d:	6f                   	outsl  %ds:(%esi),(%dx)
   e:	63 75 6d             	arpl   %esi,0x6d(%ebp)
  11:	65 6e                	outsb  %gs:(%esi),(%dx)
  13:	74 73                	je     88 <BIOS_A20_ERROR_MSG_LEN+0x3c>
  15:	2f                   	das
  16:	47                   	inc    %edi
  17:	69 74 48 75 62 2f 53 	imul   $0x74532f62,0x75(%eax,%ecx,2),%esi
  1e:	74 
  1f:	65 69 6e 65 72 4f 53 	imul   $0x2f534f72,%gs:0x65(%esi),%ebp
  26:	2f 
  27:	62 75 69             	bound  %esi,0x69(%ebp)
  2a:	6c                   	insb   (%dx),%es:(%edi)
  2b:	64 2f                	fs das
  2d:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  30:	74 2f                	je     61 <BIOS_A20_ERROR_MSG_LEN+0x15>
  32:	62 69 6f             	bound  %ebp,0x6f(%ecx)
  35:	73 2f                	jae    66 <BIOS_A20_ERROR_MSG_LEN+0x1a>
  37:	73 74                	jae    ad <BIOS_A20_ERROR_MSG_LEN+0x61>
  39:	61                   	popa
  3a:	67 65 32 00          	xor    %gs:(%bx,%si),%al
  3e:	2f                   	das
  3f:	68 6f 6d 65 2f       	push   $0x2f656d6f
  44:	6a 63                	push   $0x63
  46:	68 61 75 2f 44       	push   $0x442f7561
  4b:	6f                   	outsl  %ds:(%esi),(%dx)
  4c:	63 75 6d             	arpl   %esi,0x6d(%ebp)
  4f:	65 6e                	outsb  %gs:(%esi),(%dx)
  51:	74 73                	je     c6 <BIOS_A20_ERROR_MSG_LEN+0x7a>
  53:	2f                   	das
  54:	47                   	inc    %edi
  55:	69 74 48 75 62 2f 53 	imul   $0x74532f62,0x75(%eax,%ecx,2),%esi
  5c:	74 
  5d:	65 69 6e 65 72 4f 53 	imul   $0x2f534f72,%gs:0x65(%esi),%ebp
  64:	2f 
  65:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  68:	74 2f                	je     99 <BIOS_A20_ERROR_MSG_LEN+0x4d>
  6a:	62 69 6f             	bound  %ebp,0x6f(%ecx)
  6d:	73 2f                	jae    9e <BIOS_A20_ERROR_MSG_LEN+0x52>
  6f:	73 74                	jae    e5 <BIOS_A20_ERROR_MSG_LEN+0x99>
  71:	61                   	popa
  72:	67 65 32 2f          	xor    %gs:(%bx),%ch
  76:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  79:	74 6c                	je     e7 <BIOS_A20_ERROR_MSG_LEN+0x9b>
  7b:	6f                   	outsl  %ds:(%esi),(%dx)
  7c:	61                   	popa
  7d:	64 65 72 2e          	fs gs jb af <BIOS_A20_ERROR_MSG_LEN+0x63>
  81:	63 00                	arpl   %eax,(%eax)
  83:	2f                   	das
  84:	68 6f 6d 65 2f       	push   $0x2f656d6f
  89:	6a 63                	push   $0x63
  8b:	68 61 75 2f 44       	push   $0x442f7561
  90:	6f                   	outsl  %ds:(%esi),(%dx)
  91:	63 75 6d             	arpl   %esi,0x6d(%ebp)
  94:	65 6e                	outsb  %gs:(%esi),(%dx)
  96:	74 73                	je     10b <BIOS_A20_ERROR_MSG_LEN+0xbf>
  98:	2f                   	das
  99:	47                   	inc    %edi
  9a:	69 74 48 75 62 2f 53 	imul   $0x74532f62,0x75(%eax,%ecx,2),%esi
  a1:	74 
  a2:	65 69 6e 65 72 4f 53 	imul   $0x2f534f72,%gs:0x65(%esi),%ebp
  a9:	2f 
  aa:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  ad:	74 2f                	je     de <BIOS_A20_ERROR_MSG_LEN+0x92>
  af:	62 69 6f             	bound  %ebp,0x6f(%ecx)
  b2:	73 2f                	jae    e3 <BIOS_A20_ERROR_MSG_LEN+0x97>
  b4:	73 74                	jae    12a <BIOS_A20_ERROR_MSG_LEN+0xde>
  b6:	61                   	popa
  b7:	67 65 32 00          	xor    %gs:(%bx,%si),%al
  bb:	2f                   	das
  bc:	68 6f 6d 65 2f       	push   $0x2f656d6f
  c1:	6a 63                	push   $0x63
  c3:	68 61 75 2f 44       	push   $0x442f7561
  c8:	6f                   	outsl  %ds:(%esi),(%dx)
  c9:	63 75 6d             	arpl   %esi,0x6d(%ebp)
  cc:	65 6e                	outsb  %gs:(%esi),(%dx)
  ce:	74 73                	je     143 <BIOS_A20_ERROR_MSG_LEN+0xf7>
  d0:	2f                   	das
  d1:	47                   	inc    %edi
  d2:	69 74 48 75 62 2f 53 	imul   $0x74532f62,0x75(%eax,%ecx,2),%esi
  d9:	74 
  da:	65 69 6e 65 72 4f 53 	imul   $0x2f534f72,%gs:0x65(%esi),%ebp
  e1:	2f 
  e2:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  e5:	74 2f                	je     116 <BIOS_A20_ERROR_MSG_LEN+0xca>
  e7:	62 69 6f             	bound  %ebp,0x6f(%ecx)
  ea:	73 2f                	jae    11b <BIOS_A20_ERROR_MSG_LEN+0xcf>
  ec:	76 67                	jbe    155 <BIOS_A20_ERROR_MSG_LEN+0x109>
  ee:	61                   	popa
  ef:	00 76 67             	add    %dh,0x67(%esi)
  f2:	61                   	popa
  f3:	2e 68 00 2f 68 6f    	cs push $0x6f682f00
  f9:	6d                   	insl   (%dx),%es:(%edi)
  fa:	65 2f                	gs das
  fc:	6a 63                	push   $0x63
  fe:	68 61 75 2f 44       	push   $0x442f7561
 103:	6f                   	outsl  %ds:(%esi),(%dx)
 104:	63 75 6d             	arpl   %esi,0x6d(%ebp)
 107:	65 6e                	outsb  %gs:(%esi),(%dx)
 109:	74 73                	je     17e <BIOS_A20_ERROR_MSG_LEN+0x132>
 10b:	2f                   	das
 10c:	47                   	inc    %edi
 10d:	69 74 48 75 62 2f 53 	imul   $0x74532f62,0x75(%eax,%ecx,2),%esi
 114:	74 
 115:	65 69 6e 65 72 4f 53 	imul   $0x2f534f72,%gs:0x65(%esi),%ebp
 11c:	2f 
 11d:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 120:	74 2f                	je     151 <BIOS_A20_ERROR_MSG_LEN+0x105>
 122:	62 69 6f             	bound  %ebp,0x6f(%ecx)
 125:	73 2f                	jae    156 <BIOS_A20_ERROR_MSG_LEN+0x10a>
 127:	76 67                	jbe    190 <BIOS_A20_ERROR_MSG_LEN+0x144>
 129:	61                   	popa
 12a:	2f                   	das
 12b:	76 67                	jbe    194 <BIOS_A20_ERROR_MSG_LEN+0x148>
 12d:	61                   	popa
 12e:	2e 63 00             	arpl   %eax,%cs:(%eax)
 131:	2f                   	das
 132:	68 6f 6d 65 2f       	push   $0x2f656d6f
 137:	6a 63                	push   $0x63
 139:	68 61 75 2f 44       	push   $0x442f7561
 13e:	6f                   	outsl  %ds:(%esi),(%dx)
 13f:	63 75 6d             	arpl   %esi,0x6d(%ebp)
 142:	65 6e                	outsb  %gs:(%esi),(%dx)
 144:	74 73                	je     1b9 <BIOS_A20_ERROR_MSG_LEN+0x16d>
 146:	2f                   	das
 147:	47                   	inc    %edi
 148:	69 74 48 75 62 2f 53 	imul   $0x74532f62,0x75(%eax,%ecx,2),%esi
 14f:	74 
 150:	65 69 6e 65 72 4f 53 	imul   $0x2f534f72,%gs:0x65(%esi),%ebp
 157:	2f 
 158:	62 75 69             	bound  %esi,0x69(%ebp)
 15b:	6c                   	insb   (%dx),%es:(%edi)
 15c:	64 2f                	fs das
 15e:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 161:	74 2f                	je     192 <BIOS_A20_ERROR_MSG_LEN+0x146>
 163:	62 69 6f             	bound  %ebp,0x6f(%ecx)
 166:	73 2f                	jae    197 <BIOS_A20_ERROR_MSG_LEN+0x14b>
 168:	76 67                	jbe    1d1 <BIOS_A20_ERROR_MSG_LEN+0x185>
 16a:	61                   	popa
 16b:	00 2f                	add    %ch,(%edi)
 16d:	68 6f 6d 65 2f       	push   $0x2f656d6f
 172:	6a 63                	push   $0x63
 174:	68 61 75 2f 6f       	push   $0x6f2f7561
 179:	70 74                	jo     1ef <BIOS_A20_ERROR_MSG_LEN+0x1a3>
 17b:	2f                   	das
 17c:	63 72 6f             	arpl   %esi,0x6f(%edx)
 17f:	73 73                	jae    1f4 <BIOS_A20_ERROR_MSG_LEN+0x1a8>
 181:	2f                   	das
 182:	6c                   	insb   (%dx),%es:(%edi)
 183:	69 62 2f 67 63 63 2f 	imul   $0x2f636367,0x2f(%edx),%esp
 18a:	69 36 38 36 2d 65    	imul   $0x652d3638,(%esi),%esi
 190:	6c                   	insb   (%dx),%es:(%edi)
 191:	66 2f                	data16 das
 193:	31 36                	xor    %esi,(%esi)
 195:	2e 32 2e             	xor    %cs:(%esi),%ch
 198:	30 2f                	xor    %ch,(%edi)
 19a:	69 6e 63 6c 75 64 65 	imul   $0x6564756c,0x63(%esi),%ebp
 1a1:	00 73 74             	add    %dh,0x74(%ebx)
 1a4:	64 69 6e 74 2d 67 63 	imul   $0x6363672d,%fs:0x74(%esi),%ebp
 1ab:	63 
 1ac:	2e 68 00 73 74 64    	cs push $0x64747300
 1b2:	64 65 66 2e 68 00 73 	fs gs cs pushw $0x7300
 1b9:	74 64                	je     21f <BIOS_A20_ERROR_MSG_LEN+0x1d3>
 1bb:	61                   	popa
 1bc:	72 67                	jb     225 <BIOS_A20_ERROR_MSG_LEN+0x1d9>
 1be:	2e                   	cs
 1bf:	68                   	.byte 0x68
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 47 4e             	sub    %al,0x4e(%edi)
   8:	55                   	push   %ebp
   9:	29 20                	sub    %esp,(%eax)
   b:	31 36                	xor    %esi,(%esi)
   d:	2e 32 2e             	xor    %cs:(%esi),%ch
  10:	30 00                	xor    %al,(%eax)

Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	10 00                	adc    %al,(%eax)
   2:	00 00                	add    %al,(%eax)
   4:	ff                   	(bad)
   5:	ff                   	(bad)
   6:	ff                   	(bad)
   7:	ff 01                	incl   (%ecx)
   9:	00 01                	add    %al,(%ecx)
   b:	7c 08                	jl     15 <A20_ENABLED_MSG_LEN+0x2>
   d:	0c 04                	or     $0x4,%al
   f:	04 88                	add    $0x88,%al
  11:	01 00                	add    %eax,(%eax)
  13:	00 1c 00             	add    %bl,(%eax,%eax,1)
  16:	00 00                	add    %al,(%eax)
  18:	00 00                	add    %al,(%eax)
  1a:	00 00                	add    %al,(%eax)
  1c:	74 81                	je     ffffff9f <_cursor+0xffff78f7>
  1e:	00 00                	add    %al,(%eax)
  20:	41                   	inc    %ecx
  21:	00 00                	add    %al,(%eax)
  23:	00 41 0e             	add    %al,0xe(%ecx)
  26:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2c:	7d c5                	jge    fffffff3 <_cursor+0xffff794b>
  2e:	0c 04                	or     $0x4,%al
  30:	04 00                	add    $0x0,%al
  32:	00 00                	add    %al,(%eax)
  34:	10 00                	adc    %al,(%eax)
  36:	00 00                	add    %al,(%eax)
  38:	ff                   	(bad)
  39:	ff                   	(bad)
  3a:	ff                   	(bad)
  3b:	ff 01                	incl   (%ecx)
  3d:	00 01                	add    %al,(%ecx)
  3f:	7c 08                	jl     49 <PM_SUCCESS_MSG_LEN+0x13>
  41:	0c 04                	or     $0x4,%al
  43:	04 88                	add    $0x88,%al
  45:	01 00                	add    %eax,(%eax)
  47:	00 1c 00             	add    %bl,(%eax,%eax,1)
  4a:	00 00                	add    %al,(%eax)
  4c:	34 00                	xor    $0x0,%al
  4e:	00 00                	add    %al,(%eax)
  50:	b5 81                	mov    $0x81,%ch
  52:	00 00                	add    %al,(%eax)
  54:	17                   	pop    %ss
  55:	00 00                	add    %al,(%eax)
  57:	00 41 0e             	add    %al,0xe(%ecx)
  5a:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  60:	53                   	push   %ebx
  61:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  64:	04 00                	add    $0x0,%al
  66:	00 00                	add    %al,(%eax)
  68:	1c 00                	sbb    $0x0,%al
  6a:	00 00                	add    %al,(%eax)
  6c:	34 00                	xor    $0x0,%al
  6e:	00 00                	add    %al,(%eax)
  70:	cc                   	int3
  71:	81 00 00 1d 00 00    	addl   $0x1d00,(%eax)
  77:	00 41 0e             	add    %al,0xe(%ecx)
  7a:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  80:	57                   	push   %edi
  81:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  84:	04 00                	add    $0x0,%al
  86:	00 00                	add    %al,(%eax)
  88:	1c 00                	sbb    $0x0,%al
  8a:	00 00                	add    %al,(%eax)
  8c:	34 00                	xor    $0x0,%al
  8e:	00 00                	add    %al,(%eax)
  90:	e9 81 00 00 18       	jmp    18000116 <_cursor+0x17ff7a6e>
  95:	00 00                	add    %al,(%eax)
  97:	00 41 0e             	add    %al,0xe(%ecx)
  9a:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  a0:	54                   	push   %esp
  a1:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  a4:	04 00                	add    $0x0,%al
  a6:	00 00                	add    %al,(%eax)
  a8:	1c 00                	sbb    $0x0,%al
  aa:	00 00                	add    %al,(%eax)
  ac:	34 00                	xor    $0x0,%al
  ae:	00 00                	add    %al,(%eax)
  b0:	01 82 00 00 0c 00    	add    %eax,0xc0000(%edx)
  b6:	00 00                	add    %al,(%eax)
  b8:	41                   	inc    %ecx
  b9:	0e                   	push   %cs
  ba:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  c0:	48                   	dec    %eax
  c1:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  c4:	04 00                	add    $0x0,%al
  c6:	00 00                	add    %al,(%eax)
  c8:	1c 00                	sbb    $0x0,%al
  ca:	00 00                	add    %al,(%eax)
  cc:	34 00                	xor    $0x0,%al
  ce:	00 00                	add    %al,(%eax)
  d0:	0d 82 00 00 63       	or     $0x63000082,%eax
  d5:	00 00                	add    %al,(%eax)
  d7:	00 41 0e             	add    %al,0xe(%ecx)
  da:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  e0:	02 5f c5             	add    -0x3b(%edi),%bl
  e3:	0c 04                	or     $0x4,%al
  e5:	04 00                	add    $0x0,%al
  e7:	00 20                	add    %ah,(%eax)
  e9:	00 00                	add    %al,(%eax)
  eb:	00 34 00             	add    %dh,(%eax,%eax,1)
  ee:	00 00                	add    %al,(%eax)
  f0:	70 82                	jo     74 <BIOS_A20_ERROR_MSG_LEN+0x28>
  f2:	00 00                	add    %al,(%eax)
  f4:	7b 00                	jnp    f6 <BIOS_A20_ERROR_MSG_LEN+0xaa>
  f6:	00 00                	add    %al,(%eax)
  f8:	41                   	inc    %ecx
  f9:	0e                   	push   %cs
  fa:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 100:	44                   	inc    %esp
 101:	83 03 02             	addl   $0x2,(%ebx)
 104:	73 c5                	jae    cb <BIOS_A20_ERROR_MSG_LEN+0x7f>
 106:	c3                   	ret
 107:	0c 04                	or     $0x4,%al
 109:	04 00                	add    $0x0,%al
 10b:	00 1c 00             	add    %bl,(%eax,%eax,1)
 10e:	00 00                	add    %al,(%eax)
 110:	34 00                	xor    $0x0,%al
 112:	00 00                	add    %al,(%eax)
 114:	eb 82                	jmp    98 <BIOS_A20_ERROR_MSG_LEN+0x4c>
 116:	00 00                	add    %al,(%eax)
 118:	c8 00 00 00          	enter  $0x0,$0x0
 11c:	41                   	inc    %ecx
 11d:	0e                   	push   %cs
 11e:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 124:	02 c4                	add    %ah,%al
 126:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 129:	04 00                	add    $0x0,%al
 12b:	00 1c 00             	add    %bl,(%eax,%eax,1)
 12e:	00 00                	add    %al,(%eax)
 130:	34 00                	xor    $0x0,%al
 132:	00 00                	add    %al,(%eax)
 134:	b3 83                	mov    $0x83,%bl
 136:	00 00                	add    %al,(%eax)
 138:	3d 00 00 00 41       	cmp    $0x41000000,%eax
 13d:	0e                   	push   %cs
 13e:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 144:	79 c5                	jns    10b <BIOS_A20_ERROR_MSG_LEN+0xbf>
 146:	0c 04                	or     $0x4,%al
 148:	04 00                	add    $0x0,%al
 14a:	00 00                	add    %al,(%eax)
 14c:	1c 00                	sbb    $0x0,%al
 14e:	00 00                	add    %al,(%eax)
 150:	34 00                	xor    $0x0,%al
 152:	00 00                	add    %al,(%eax)
 154:	f0 83 00 00          	lock addl $0x0,(%eax)
 158:	ca 00 00             	lret   $0x0
 15b:	00 41 0e             	add    %al,0xe(%ecx)
 15e:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 164:	02 c6                	add    %dh,%al
 166:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 169:	04 00                	add    $0x0,%al
 16b:	00 1c 00             	add    %bl,(%eax,%eax,1)
 16e:	00 00                	add    %al,(%eax)
 170:	34 00                	xor    $0x0,%al
 172:	00 00                	add    %al,(%eax)
 174:	ba 84 00 00 5a       	mov    $0x5a000084,%edx
 179:	00 00                	add    %al,(%eax)
 17b:	00 41 0e             	add    %al,0xe(%ecx)
 17e:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 184:	02 56 c5             	add    -0x3b(%esi),%dl
 187:	0c 04                	or     $0x4,%al
 189:	04 00                	add    $0x0,%al
 18b:	00 1c 00             	add    %bl,(%eax,%eax,1)
 18e:	00 00                	add    %al,(%eax)
 190:	34 00                	xor    $0x0,%al
 192:	00 00                	add    %al,(%eax)
 194:	14 85                	adc    $0x85,%al
 196:	00 00                	add    %al,(%eax)
 198:	10 01                	adc    %al,(%ecx)
 19a:	00 00                	add    %al,(%eax)
 19c:	41                   	inc    %ecx
 19d:	0e                   	push   %cs
 19e:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 1a4:	03 0c 01             	add    (%ecx,%eax,1),%ecx
 1a7:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 1aa:	04 00                	add    $0x0,%al
