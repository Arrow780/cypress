_ = require("lodash")

$Chainer = require("../../cypress/chainer")
$errUtils = require("../../cypress/error_utils")

command = (ctx, name, args...) ->
  if not ctx[name]
    cmds = "\`#{_.keys($Chainer.prototype).join("`, `")}\`"
    $errUtils.throwErrByPath("miscellaneous.invalid_command", {
      args: { name, cmds }
    })

  ctx[name].apply(ctx, args)

module.exports = (Commands, Cypress, cy, state, config) ->
  Commands.addChainer({
    ## invocationStack has to be passed in here, but can be ignored
    command: (chainer, invocationStack, args) ->
      command(chainer, args...)
  })

  Commands.addAllSync({
    command: (args...) ->
      args.unshift(cy)

      command.apply(window, args)
  })
