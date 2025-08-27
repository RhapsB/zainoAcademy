from django.urls import path
from . import views

urlpatterns = [
    path('', views.inicio, name='home'),
    path('nosotros/',views.nosotros, name='nosotros'),
    path('contacto/',views.contacto, name='contacto'),
    path('precios/',views.precios, name='precios'),
    path('login/', views.login_view, name='login'),

    # Dashboards
    path('estudiantes/', views.dashboard_estudiantes, name='dashboard_estudiantes'),
    path('profesores/', views.dashboard_profesores, name='dashboard_profesores'),
    path('directivos/', views.dashboard_directivos, name='dashboard_directivos'),
    path('acudientes/', views.dashboard_acudientes, name='dashboard_acudientes'),

    #Directivos
    path('directivos/',views.dashboard_cargo_directivos, name='cargo_directivo'),

    # Acudientes
    path('acudientes/actividades/', views.actividades_acudientes, name='actividades_acudientes'),
    path('acudientes/asistencia/', views.asistencia_acudientes, name='asistencia_acudientes'),
    path('acudientes/notificaciones/', views.notificaciones_acudientes, name='notificaciones_acudientes'),
    path('acudientes/editar_perfil/', views.editar_perfil_acudientes, name='editar_perfil_acudientes'),
    path('acudientes/actualizar_perfil/', views.actualizar_perfil_acudientes, name='actualizar_perfil_acudientes'),
    path('acudientes/dashboard_acudientes/', views.dashboard_acudientes_calendar, name="dashboard_acudientes"),
    path('acudientes/actividades_list/', views.actividades_list_acudientes, name='actividades_list_acudientes'),
    path('acudientes/asistencia_list/', views.asistencia_list_acudientes, name='asistencia_list_acudientes'),
    path('asistencia/pdf/', views.asistencia_pdf_acudientes, name='asistencia_pdf_acudientes'),
]