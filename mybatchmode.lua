texconfig.interaction = 0           -- Activate batchmode
texconfig.halt_on_error = true -- Stop at first error

callback.register('show_error_message', function(...)
  texio.write_nl('term and log', status.lasterrorstring)
  texio.write('term', '.\n')
end)
callback.register('show_lua_error_hook', function(...)
  texio.write_nl('term and log', status.lastluaerrorstring)
  texio.write('term', '.\n')
end)
