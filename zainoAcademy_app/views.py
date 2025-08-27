from django.shortcuts import render, redirect
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse, JsonResponse, FileResponse
from .models import Usuario, TipoUsuario, Directivos, Actividad, Acudiente, Estudiantes, Estudiante_Curso, Actividad_Entrega, Periodo, Boletin, Asistencia
from datetime import date
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet
import json, io

#Paginas Estaticas:
def inicio(request):
    return render (request, "staticPage/index.html")

def nosotros(request):
    return render (request, "staticPage/nosotros.html")

def contacto(request):
    return render (request, "staticPage/contacto.html")

def precios(request):
    return render (request, "staticPage/precio.html")


#Loggin 
def redirect_to_login(request):
    return redirect('login')


def login_view(request):
    mensaje = ''
    if request.method == 'POST':
        correo = request.POST.get('correo', '').strip()
        contraseña = request.POST.get('contraseña', '').strip()

        try:
            usuario = Usuario.objects.get(correo=correo, Us_contraseña=contraseña)
            
            
            # Guardamos el usuario en sesión
            request.session['usuario_id'] = usuario.Us_id
            request.session['tipo_usuario'] = usuario.TipoUsuario.TusTiposUsuario
            request.session['usuario_nombre'] = usuario.Us_nombre

            # Obtener cargo si es directivo
            try:
                directivo = Directivos.objects.get(Us_id=usuario.Us_id)
                request.session['Dir_cargo'] = directivo.Dir_cargo
            except Directivos.DoesNotExist:
                request.session['Dir_cargo'] = None

            # Redirigir según tipo de usuario
            tipo_id = usuario.TipoUsuario.Tus_id

            if tipo_id == 2:  # estudiante
                return redirect('dashboard_estudiantes')
            elif tipo_id == 1:  # profesor
                return redirect('dashboard_profesores')
            elif tipo_id == 3:  # directivo
                return redirect('dashboard_directivos')
            elif tipo_id == 4:  # acudiente
                return redirect('dashboard_acudientes')
            else:
                mensaje = 'Tipo de usuario no válido'

        except Usuario.DoesNotExist:
            mensaje = 'Correo o contraseña incorrectos'

    return render(request, 'registration/login.html', {'mensaje': mensaje})

def get_usuario_from_session(request):
    usuario_id = request.session.get('usuario_id')
    if usuario_id:
        try:
            return Usuario.objects.get(Us_id=usuario_id)
        except Usuario.DoesNotExist:
            return None
    return None

def get_cargo_directivo(request):
    usuario_id = request.session.get('usuario_id')
    if usuario_id:
        try:
            directivo = Directivos.objects.get(Us_id=usuario_id)  # Buscar el directivo por su usuario
            return directivo.Dir_cargo
        except Directivos.DoesNotExist:
            return None
    return None



@csrf_exempt
def actualizar_perfil_acudientes(request):
    if request.method == 'POST':
        usuario = get_usuario_from_session(request)
        if not usuario:
            return JsonResponse({'error': 'Usuario no autenticado'}, status=403)

        try:
            data = json.loads(request.body.decode('utf-8'))

            usuario.Us_nombre = data.get('username', usuario.Us_nombre)
            usuario.correo = data.get('email', usuario.correo)
            usuario.Us_contraseña = data.get('password', usuario.Us_contraseña)

            # ✅ Solución: asegurarse de que fecha_registro tenga un valor
            if not usuario.fecha_registro:
                usuario.fecha_registro = date.today()

            usuario.save()

            # Actualizamos el nombre en la sesión
            request.session['usuario_nombre'] = usuario.Us_nombre

            return JsonResponse({'success': True})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)

    return JsonResponse({'error': 'Método no permitido'}, status=405)

# Dashboards simples para probar
def dashboard_estudiantes(request):
    return HttpResponse('<h1>Dashboard Estudiantes - Login Exitoso!</h1>')

def dashboard_profesores(request):
    return HttpResponse('<h1>Dashboard Profesores - Login Exitoso!</h1>')

#Directivos

def dashboard_directivos(request):
    usuario = get_usuario_from_session(request)
    return render(request, 'directivos/dashboard_directivos.html', {'usuario': usuario})
    

def dashboard_cargo_directivos(request):
    cargo = get_cargo_directivo(request)
    return render(request, 'directivos/dashboard_directivos.html', {'cargo' : cargo})

#Acudiente

def dashboard_acudientes(request):
    try:
        usuario = get_usuario_from_session(request)
        if not usuario:
            return redirect('login')

        # traer acudiente y estudiantes a cargo
        acudiente = Acudiente.objects.get(Usuario_Us=usuario)
        estudiantes_a_cargo = [acudiente.Estudiantes_Est]

        actividades_pendientes = []
        if estudiantes_a_cargo:
            actividades_pendientes = Actividad.objects.filter(
                Esta_Actividad_id=2,
                Bol__Cur__estudiante_curso__Est=estudiantes_a_cargo[0]
            ).select_related('Bol__Mtr', 'Esta_Actividad')

        context = {
            'usuario': usuario,
            'estudiantes_a_cargo': estudiantes_a_cargo,
            'actividades_pendientes': actividades_pendientes,
            'total_pendientes': len(actividades_pendientes),
        }
        return render(request, 'acudientes/dashboard_acudientes.html', context)

    except Exception as e:
        print(f"❌ Error en dashboard_acudientes: {e}")
        return render(request, 'acudientes/dashboard_acudientes.html', {
            'usuario': None,
            'estudiantes_a_cargo': [],
            'actividades_pendientes': [],
            'total_pendientes': 0,
        })


def dashboard_acudientes_calendar(request):
    usuario = get_usuario_from_session(request)
    if not usuario:
        return redirect('login')

    # Aseguramos que fecha_registro no esté vacío
    if not usuario.fecha_registro:
        usuario.fecha_registro = date.today()
        usuario.save()

    today = date.today().isoformat()  # Para el input date

    return render(request, "acudientes/dashboard_acudientes.html", {
        "usuario": usuario,
        "today": today
    })

def actividades_acudientes(request):
    usuario = get_usuario_from_session(request)
    if not usuario:
        return redirect('login')
    
    try:
        # Obtener el acudiente basado en el usuario de la sesión
        acudiente = Acudiente.objects.get(Usuario_Us=usuario)
        
        # Obtener todos los estudiantes a cargo de este acudiente
        # Nota: Según tu modelo, un acudiente tiene UN estudiante (ForeignKey)
        # Si quieres que sea muchos estudiantes, deberías cambiar el modelo
        estudiantes_a_cargo = [acudiente.Estudiantes_Est]
        
        # Si quisieras múltiples estudiantes, usarías:
        # estudiantes_a_cargo = Acudiente.objects.filter(Usuario_Us=usuario).select_related('Estudiantes_Est')
        
        context = {
            'usuario': usuario,
            'estudiantes_a_cargo': estudiantes_a_cargo,
        }
        
        return render(request, 'acudientes/actividades_acudientes.html', context)
        
    except Acudiente.DoesNotExist:
        # Si no existe el acudiente, mostrar página sin estudiantes
        context = {
            'usuario': usuario,
            'estudiantes_a_cargo': [],
        }
        return render(request, 'acudientes/actividades_acudientes.html', context)

def asistencia_acudientes(request):
    usuario = get_usuario_from_session(request)
    if not usuario:
        return redirect('login')
    
    try:
        # Obtener el acudiente basado en el usuario de la sesión
        acudiente = Acudiente.objects.get(Usuario_Us=usuario)
        
        # Obtener todos los estudiantes a cargo de este acudiente
        estudiantes_a_cargo = [acudiente.Estudiantes_Est]
        
        # Si quisieras múltiples estudiantes, usarías:
        # estudiantes_a_cargo = Acudiente.objects.filter(Usuario_Us=usuario).select_related('Estudiantes_Est')
        
        context = {
            'usuario': usuario,
            'estudiantes_a_cargo': estudiantes_a_cargo,
        }
        
        return render(request, 'acudientes/asistencia_acudientes.html', context)
        
    except Acudiente.DoesNotExist:
        # Si no existe el acudiente, mostrar página sin estudiantes
        context = {
            'usuario': usuario,
            'estudiantes_a_cargo': [],
        }
        return render(request, 'acudientes/asistencia_acudientes.html', context)

def notificaciones_acudientes(request):
    usuario = get_usuario_from_session(request)
    return render(request, 'acudientes/notificaciones_acudientes.html', {'usuario': usuario})

def editar_perfil_acudientes(request):
    usuario = get_usuario_from_session(request)
    return render(request, 'acudientes/editar_perfil_acudientes.html', {'usuario': usuario})

def actividades_list_acudientes(request):
    usuario = get_usuario_from_session(request)
    estudiante_id = request.POST.get('student_id')  # Obtiene el ID del estudiante desde el formulario

    # Obtener el estudiante asociado al acudiente (solo si el estudiante existe)
    if estudiante_id:
        try:
            estudiante = Estudiantes.objects.get(Est_id=estudiante_id)
            # Usar solo 'Act' y 'Bol' en select_related
            actividades = Actividad_Entrega.objects.filter(Est=estudiante).select_related('Act', 'Act__Bol', 'Act__Esta_Actividad')
        except Estudiantes.DoesNotExist:
            actividades = []
    else:
        actividades = []

    return render(request, 'acudientes/actividades_list_acudientes.html', {
        'usuario': usuario,
        'actividades': actividades,
    })

def asistencia_list_acudientes(request):
    usuario = get_usuario_from_session(request)
    if not usuario:
        return redirect('login')

    estudiante = None
    periodos = []

    try:
        # Obtener el acudiente asociado al usuario
        acudiente = Acudiente.objects.get(Usuario_Us=usuario)

        # Tomar el estudiante a cargo (siempre 1 según tu modelo)
        estudiante = acudiente.Estudiantes_Est  

        if estudiante:
            # Guardamos en sesión por si se necesita luego
            request.session["student_id"] = estudiante.Est_id

            # Buscar periodos a los que pertenece este estudiante
            periodos = Periodo.objects.filter(
                boletin__Cur__estudiante_curso__Est=estudiante
            ).distinct()

    except Acudiente.DoesNotExist:
        pass

    return render(request, "acudientes/asistencia_list_acudientes.html", {
        "usuario": usuario,
        "estudiante": estudiante,
        "periodos": periodos
    })

def asistencia_pdf_acudientes(request):
    usuario = get_usuario_from_session(request)
    periodo_id = request.POST.get("periodo_id")
    estudiante_id = request.session.get("student_id")

    if not (periodo_id and estudiante_id):
        return HttpResponse("Faltan datos", status=400)

    try:
        # estudiante
        estudiante = Estudiantes.objects.get(Est_id=estudiante_id)
        # periodo
        periodo = Periodo.objects.get(Per_id=periodo_id)
        # estudiante_curso
        est_curso = Estudiante_Curso.objects.get(Est=estudiante)
    except (Estudiantes.DoesNotExist, Periodo.DoesNotExist, Estudiante_Curso.DoesNotExist):
        return HttpResponse("Datos no encontrados", status=404)

    # 🔎 Traer la asistencia real de ese estudiante y periodo
    asistencias = Asistencia.objects.filter(
        Est_Cur=est_curso,
        Est_Cur__Cur__boletin__Per=periodo   # ← ajusta si tu Periodo se relaciona distinto
    ).select_related("Esta_Asistencia").order_by("Ast_fecha")

    buffer = io.BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=letter)
    elements = []
    styles = getSampleStyleSheet()

    # ====== Encabezado ======
    elements.append(Paragraph(f"Asistencia - {periodo.Per_nombre}", styles["Title"]))
    elements.append(Spacer(1, 12))
    elements.append(Paragraph(f"<b>Estudiante:</b> {estudiante.Usuario_us.Us_nombre}", styles["Normal"]))
    elements.append(Spacer(1, 20))

    # ====== Tabla ======
    data = [["Fecha", "Estado"]]  # cabecera
    if asistencias.exists():
        for a in asistencias:
            data.append([a.Ast_fecha.strftime("%Y-%m-%d"), a.Esta_Asistencia.Esta_Asistencia_Estado])
    else:
        data.append(["Sin registros", "-"])

    table = Table(data, colWidths=[200, 200])

    table.setStyle(TableStyle([
        ("BACKGROUND", (0,0), (-1,0), colors.HexColor("#1e91d6")),
        ("TEXTCOLOR", (0,0), (-1,0), colors.whitesmoke),
        ("ALIGN", (0,0), (-1,-1), "CENTER"),
        ("FONTNAME", (0,0), (-1,0), "Helvetica-Bold"),
        ("FONTSIZE", (0,0), (-1,0), 12),
        ("BOTTOMPADDING", (0,0), (-1,0), 10),
        ("GRID", (0,0), (-1,-1), 1, colors.black),
        ("BACKGROUND", (0,1), (-1,-1), colors.HexColor("#f9f9f9")),
    ]))

    elements.append(table)

    doc.build(elements)

    buffer.seek(0)
    return FileResponse(buffer, as_attachment=True, filename=f"Asistencia_{estudiante.Usuario_us.Us_nombre}.pdf")