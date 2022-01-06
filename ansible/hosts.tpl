[frontend]
%{ for ip in frontend ~}
${ip}
%{ endfor ~}

[backend]
%{ for ip in backend ~}
${ip}
%{ endfor ~}

[all]
%{ for ip in frontend ~}
${ip}
%{ endfor ~}
%{ for ip in backend ~}
${ip}
%{ endfor ~}

